extends CharacterBody2D
class_name Fish

const MAX_PLAYER_DISTANCE:=400.0

@export
var speed:=30.0

@onready var sprite = $Sprite


func _ready():
	Events.player_position_updated.connect(_on_player_position_updated)
	
func _on_player_position_updated(pos:Vector2):
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
