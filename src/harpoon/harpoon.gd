class_name Harpoon extends Node2D

@export var rope_max_length: int = 100
@export var rope_amplitude: float = 1
@export var rope_period: float = 1
@export var rope_step: float = 1

@export var shoot_speed: float = 250
@export var reel_speed: float = 500


var rope_points: Array[Vector2]


@onready var arrow = $ArrowHead
@onready var rope = $Rope
@onready var state_machine = $State


func _ready() -> void:
	pass
	

func _draw() -> void:
	if (rope.visible):
		return
	
	var color = rope.default_color
	for point in rope_points:
		draw_line(Vector2(point.x - 0.5, point.y - 0.5), Vector2(point.x + 0.5, point.y + 0.5), color)
	
	

func _physics_process(_delta: float) -> void:
	rope_points = _calculate_rope()
	rope.points = rope_points
	queue_redraw()
	

func _calculate_rope() -> Array[Vector2]:
	var first_point = Vector2.ZERO
	var last_point = arrow.position
	var distance = first_point.distance_to(last_point)
	
	var max_waves = distance / PI
	var desired_waves = int(distance / rope_period)
	var factor = desired_waves * PI / distance
	
	var amplitude = 0
	if state_machine.is_active("Shooting"):
		amplitude = rope_amplitude
	
	var points:Array[Vector2] = [first_point]
	var current = rope_step
	while current < distance:
		var point = Vector2(int(current), int(amplitude * sin(current * factor)))
		points.append(point)
		current += rope_step
		
	points.append(last_point)
	
	return points
	

