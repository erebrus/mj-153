extends Node

signal thrust_requested()
signal thrust_stopped()
signal shoot_requested(target:Vector2)
signal player_position_updated(pos:Vector2)

signal fish_captured(fish: Fish)
