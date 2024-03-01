extends State

var arrow: Area2D


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	Logger.debug("reeling")
	arrow = target.arrow
	

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(delta: float) -> void:
	var distance = arrow.position.length_squared()
	var movement = target.reel_speed * delta
	
	if (distance < pow(movement,2)):
		arrow.position = Vector2.ZERO
		change_state("Idle")
		return
	
	arrow.position -= Vector2(movement, 0)
