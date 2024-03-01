extends State


var arrow: Area2D


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	Logger.debug("shooting")
	arrow = target.arrow
	arrow.area_entered.connect(_on_harpoon_hit)
	

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(delta: float) -> void:
	var distance = arrow.position.length_squared()
	
	if (distance > pow(target.rope_max_length, 2)):
		change_state("Reeling")
		return
	
	arrow.position += Vector2(target.shoot_speed * delta, 0)
	

# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	arrow.area_entered.disconnect(_on_harpoon_hit)
	

func _on_harpoon_hit(area: Area2D) -> void:
	Logger.debug("harpoon hit")
	change_state("Reeling")
