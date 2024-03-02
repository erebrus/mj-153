extends Control



var fishes: int = 0

@onready var fish_counter = $FishCounter


func _ready() -> void:
	Events.fish_captured.connect(_on_fish_captured)
	fish_counter.text = str(fishes)
	

func _on_fish_captured(_fish: Fish) -> void:
	fishes += 1
	fish_counter.text = str(fishes)
