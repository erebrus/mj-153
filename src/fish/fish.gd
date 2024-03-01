class_name Fish extends RigidBody2D


@onready var sprite = $Sprite


func spear() -> void:
	Logger.debug("fish speared")
	sprite.stop()
	

func capture() -> void:
	Logger.debug("fish captured")
	Events.fish_captured.emit(self)
	queue_free()
