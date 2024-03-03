extends CharacterBody2D

@export
var speed:float = 10
var direction:Vector2 = Vector2.UP


func _ready():
	velocity = speed * direction
	
func _physics_process(delta):
	var col:KinematicCollision2D  = move_and_collide(velocity * delta)
	if col and col.get_collider() is Player:
		col.get_collider().crush()
		
	
