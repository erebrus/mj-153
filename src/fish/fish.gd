extends CharacterBody2D
class_name Fish

const MAX_PLAYER_DISTANCE:=400.0

@export var speed:=30.0
@export var runs_away := true
@export var faces_running_direction := true

@onready var sprite = $Sprite
@onready var sound = $HitSound
@onready var reaction_timer = $ReactionTimer
var last_player_position:Vector2 


func _ready():
	Events.player_position_updated.connect(_on_player_position_updated)
	if not runs_away:
		$DetectionBox/CollisionShape2D.disabled = true
	
func _on_player_position_updated(pos:Vector2):
	last_player_position = pos
	if global_position.distance_to(pos) > MAX_PLAYER_DISTANCE:
		Logger.info("%s destroyed " % name)
		queue_free()

func _physics_process(_delta):
	if faces_running_direction:
		rotation = Globals._force_angle_precision(rotation, PI / 2)
	else:
		sprite.rotation = -rotation + Globals._force_angle_precision(rotation, PI / 2)
	
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	move_and_slide()

func spear() -> void:
	Logger.debug("fish speared")
	sound.play()
	sprite.stop()
	

func capture() -> void:
	Logger.debug("fish captured")
	Events.fish_captured.emit(self)
	queue_free()


func _on_detection_box_body_entered(_body):
	Logger.info("%s detected player")
	reaction_timer.start()


func _on_detection_box_body_exited(_body):
	reaction_timer.stop()

func _on_reaction_timer_timeout():
	Logger.info("%s running away")
	rotation = last_player_position.angle_to_point(global_position)
