extends Node

signal thrust_requested()
signal thrust_stopped()
signal shoot_requested(target:Vector2)
signal player_position_updated(pos:Vector2)

signal fish_captured(fish: Fish)

signal oxygen_consumed(amount: int)
signal oxygen_restored(amount: int)
signal oxygen_out

signal game_over
signal score_changed(score: int)
