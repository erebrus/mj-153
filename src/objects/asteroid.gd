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
var last_player_position:Vector2 

func _ready():
	sprite.texture = TEXTURES[randi() % TEXTURES.size()]
	velocity = randf()* \
		((speed_interval.y - speed_interval.x) +speed_interval.x )\
		 * direction

	Events.player_position_updated.connect(_on_player_position_updated)
	
func _on_player_position_updated(pos:Vector2):
	last_player_position = pos	
		
func _physics_process(delta):
	var col:KinematicCollision2D  = move_and_collide(velocity * delta)
	if col and col.get_collider() is Player:
		col.get_collider().crush()
		collision_mask=0
		
	

func _on_timer_timeout():
	var dist := last_player_position.distance_to(global_position)
	if dist > 350:
		queue_free()
	else:
		$Timer.start()
