extends "res://src/harpoon/states/moving.gd"

var shooting_direction: Vector2
var target_position: Vector2

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(args) -> void:
	Logger.debug("shooting")
	super._on_enter(args)
	arrow.area_entered.connect(_on_harpoon_hit)
	Events.shoot_requested.emit(args)
	shooting_direction = target.global_position.direction_to(args)
	target_position = target.global_position + target.rope_max_length * shooting_direction
	Logger.debug("target position %s" % target_position)
	target.shoot_sound.pitch_scale = randf_range(0.9, 1.1)
	target.shoot_sound.play()
	

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(delta: float) -> void:
	var distance = arrow.position.length_squared()
	var direction = target.global_position.direction_to(target_position)
	
	if (distance > pow(target.rope_max_length, 2)):
		change_state("Reeling")
		return
	
	arrow.global_position += target.shoot_speed * delta * direction
	
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
