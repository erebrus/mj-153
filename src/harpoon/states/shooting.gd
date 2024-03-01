extends "res://src/harpoon/states/moving.gd"


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(args) -> void:
	Logger.debug("shooting")
	super._on_enter(args)
	arrow.area_entered.connect(_on_harpoon_hit)
	

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(delta: float) -> void:
	var distance = arrow.position.length_squared()
	
	if (distance > pow(target.rope_max_length, 2)):
		change_state("Reeling")
		return
	
	arrow.position += Vector2(target.shoot_speed * delta, 0)
	
	super._on_update(delta)
	

# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(args) -> void:
	super._on_exit(args)
	arrow.area_entered.disconnect(_on_harpoon_hit)
	

func _on_harpoon_hit(area: Area2D) -> void:
	Logger.debug("harpoon hit")
	if area.owner is Fish:
		area.owner.spear()
		captured.append(area.owner)
	
	change_state("Reeling", captured.duplicate())
