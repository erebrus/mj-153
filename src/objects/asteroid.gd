extends CharacterBody2D

const TEXTURES:Array[Texture]=[
	preload("res://assets/gfx/objects/asteroid1.png"),
	preload("res://assets/gfx/objects/asteroid2.png"),
	preload("res://assets/gfx/objects/asteroid3.png")
	]

@export
var speed_interval:Vector2 = Vector2(20,80)
var direction:Vector2 = Vector2.UP

@onready var sprite = $Sprite2D


func _ready():
	sprite.texture = TEXTURES[randi() % TEXTURES.size()]
	#velocity = randf()* \
		#((speed_interval.y - speed_interval.x) +speed_interval.x )\
		 #* direction
	
func _physics_process(delta):
	var col:KinematicCollision2D  = move_and_collide(velocity * delta)
	if col and col.get_collider() is Player:
		col.get_collider().crush()
		
	
