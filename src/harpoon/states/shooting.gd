extends State


var arrow: Area2D


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	Logger.debug("shooting")
	arrow = target.arrow
	

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(delta: float) -> void:
	var distance = arrow.position.length_squared()
	
	if (distance > pow(target.rope_max_length, 2)):
		change_state("Reeling")
		return
	
	arrow.position += Vector2(target.shoot_speed * delta, 0)
	
