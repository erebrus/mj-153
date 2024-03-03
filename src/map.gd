extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Events.oxygen_out.connect(_on_game_over)
	Events.game_over.connect(_on_game_over)


func _physics_process(_delta):
	$Spawners.global_position = $Player/Camera2D.global_position - Vector2(160, 90)
	

func _on_game_over():
	Globals.game_over()
	

