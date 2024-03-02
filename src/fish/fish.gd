extends CharacterBody2D
class_name Fish

const MAX_PLAYER_DISTANCE:=400.0

@export var speed:=30.0
@export var runs_away := true


@onready var sprite = $Sprite
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

func _physics_process(delta):

	velocity = Vector2.RIGHT.rotated(rotation) * speed

	move_and_slide()

func spear() -> void:
	Logger.debug("fish speared")
	sprite.stop()
	

func capture() -> void:
	Logger.debug("fish captured")
	Events.fish_captured.emit(self)
	queue_free()


func _on_detection_box_body_entered(body):
	Logger.info("%s detected player")
	reaction_timer.start()


func _on_detection_box_body_exited(body):
	reaction_timer.stop()

func _on_reaction_timer_timeout():
	Logger.info("%s running away")
	rotation = last_player_position.angle_to_point(global_position)
