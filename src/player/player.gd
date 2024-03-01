extends RigidBody2D

@export
var impulse_force:float = 1000.0

@export
var shoot_impulse_force:float = 200.0

var thrust_on:bool = false

var target_angle:float

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.thrust_requested.connect(_on_thrust_requested)
	Events.thrust_stopped.connect(_on_thrust_stopped)
	Events.shoot_requested.connect(_on_shoot_requested)
	_on_timer_timeout()

func _on_shoot_requested(pos:Vector2):
	Logger.info("%s received shoot request pos %s" % [name, pos])
	_shoot(pos)
	var angle = pos.angle_to_point(global_position)
	var impulse = Vector2.RIGHT.rotated(angle) * -shoot_impulse_force
	apply_impulse(impulse)
	
func _shoot(pos):
	Logger.info("%s shooting at %s" % [name, pos])
	pass
	
	
func _on_thrust_stopped():
	thrust_on = false

func _on_thrust_requested():
	thrust_on = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if angle_difference(rotation, target_angle) < PI/60:
		rotation = target_angle
	else:
		rotation=lerp_angle(rotation, target_angle, .8)
	if thrust_on:
		var impulse = Vector2.RIGHT.rotated(rotation)*-impulse_force
		apply_force(impulse)
	
func _set_target_angle():
	var pos = get_global_mouse_position()
	target_angle = pos.angle_to_point(global_position)

func _start_thrust():
	Logger.info("thrust start")
	thrust_on = true
	_set_target_angle()
	animation_player.play("thrust_start")
	await animation_player.animation_finished
	if thrust_on:
		animation_player.play("thrust")

func _stop_thrust():
	Logger.info("thrust stop")
	thrust_on = false
	#if animation_player.is_playing() and nimation_player.current_animation == "thrust_start":				
	animation_player.play("thrust_stop")
	
func _input(event):
	if event is InputEventMouseMotion:
		_set_target_angle()
		return
	if event is InputEventMouseButton:
		var m_event:InputEventMouseButton = event as InputEventMouseButton
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if not thrust_on and m_event.pressed:
				_start_thrust()				
			elif thrust_on and not m_event.pressed:
				_stop_thrust()


func _on_timer_timeout():
	Events.player_position_updated.emit(global_position)
