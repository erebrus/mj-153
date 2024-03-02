extends "res://src/harpoon/states/moving.gd"


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(args) -> void:
	Logger.debug("reeling")
	super._on_enter(args)
	if args != null:
		captured = args
	

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(delta: float) -> void:
	var distance = arrow.position.length_squared()
	var direction = arrow.position.normalized()
	var movement = target.reel_speed * delta
	
	if (distance < pow(movement,2)):
		arrow.position = Vector2.ZERO
		for fish in captured:
			fish.capture()
		
		change_state("Idle")
		return
	
	arrow.position -= movement * direction
	
	super._on_update(delta)
