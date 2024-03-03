extends Area2D

@export
var min_force:float=200
@export
var max_force:float=3000
@export
var crush_distance:float = 8.0

var target

@onready var sprite = $Sprite
@onready var collision_shape_2d = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")

func _physics_process(_delta):
	if target:
		var force_direction  = (global_position-target.global_position).normalized()
		target.apply_central_force(force_direction * _compute_force(target))
	
		var dist = target.global_position.distance_to(global_position)
		if dist < crush_distance:
			target.crush()
			if target is Player:
				monitoring = false
			
func _compute_force(_target):
	var radius = collision_shape_2d.shape.radius
	var dist = target.global_position.distance_to(global_position)
	var force_ratio = (radius-dist)/radius
	var force = lerpf(min_force, max_force, force_ratio)
	return force
	
func _on_body_entered(body):
	target=body


func _on_body_exited(body):
	target=null


