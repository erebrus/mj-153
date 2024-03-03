extends Node

@export var asteroid_speed: float = 0.05

@onready var asteroid = %Asteroid
@onready var asteroid2 = %Asteroid2
@onready var asteroid3 = %Asteroid3


var can_exit = false


func _ready() -> void:
	%FishCounter.number = Globals.score
	
	await get_tree().create_timer(0.3).timeout
	can_exit = true
	

func _physics_process(delta: float) -> void:
	asteroid.progress_ratio += delta * asteroid_speed
	asteroid2.progress_ratio += delta * asteroid_speed
	asteroid3.progress_ratio += delta * asteroid_speed
	

func _input(event: InputEvent):
	if not can_exit:
		return
	if event is InputEventKey or event is InputEventMouseButton:
		Globals.start()
	

func _on_restart_timer_timeout():
	Globals.start()
