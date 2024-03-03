extends AnimatedSprite2D


func _ready() -> void:
	var time = randf_range(0.2,7)
	get_tree().create_timer(time).timeout.connect(burst)
	

func burst() -> void:
	play("default")
	var time = randf_range(2,7)
	get_tree().create_timer(time).timeout.connect(burst)
	

