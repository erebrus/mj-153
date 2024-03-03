extends Control


@onready var fish_counter = %FishCounter


func _ready() -> void:
	Events.score_changed.connect(_on_score_changed)
	fish_counter.number = Globals.score
	

func _on_score_changed(score: int) -> void:
	fish_counter.number = score
