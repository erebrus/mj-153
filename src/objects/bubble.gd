extends Area2D

@export 
var air:float=10

@onready var sprite = $Sprite

@onready var pop = $pop

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")


	
	
func _pop():
	sprite.play("pop")
	pop.play()
	await pop.finished
	queue_free()


func _on_body_entered(body):	
	Events.oxygen_restored.emit(air)
	_pop()

