extends Control
@onready var click = $click


func _on_start_button_pressed():
	click.play()
	await click.finished
	Globals.start()
