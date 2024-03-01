extends RigidBody2D

@export
var impulse_force:float = 1000.0

@export
var shoot_impulse_force:float = 200.0

var thrust_on:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.thrust_requested.connect(_on_thrust_requested)
	Events.thrust_stopped.connect(_on_thrust_stopped)
	Events.shoot_requested.connect(_on_shoot_requested)

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
	if thrust_on:
		var pos = get_global_mouse_position()
		var angle = pos.angle_to_point(global_position)
		var impulse = Vector2.RIGHT.rotated(angle)*impulse_force
		apply_force(impulse)
	

