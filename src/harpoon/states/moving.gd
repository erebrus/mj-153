extends State

var arrow: Area2D
var captured: Array

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	arrow = target.arrow
	

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	target.global_rotation = 0
	arrow.global_rotation = target.global_position.angle_to_point(arrow.global_position)
	move_captures()
	

# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	captured.clear()
	

func move_captures() -> void:
	for fish in captured:
		fish.global_position = arrow.global_position
