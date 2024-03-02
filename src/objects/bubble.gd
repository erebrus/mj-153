extends Area2D

@export 
var air:float=10

@onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")


	
	
func _pop():
	sprite.play("pop")
	await sprite.animation_finished
	queue_free()


func _on_body_entered(body):
	body.add_air(air)
	_pop()
