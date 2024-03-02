extends State


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	Logger.debug("harpoon idle")
	if target.arrow != null:
		target.arrow.visible = false

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		change_state("Shooting", target.get_global_mouse_position())
	

# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(args) -> void:
	target.arrow.visible = true
