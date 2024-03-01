extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _input(event):
	#if event is InputEventMouseButton:
		#var m_event:InputEventMouseButton = event as InputEventMouseButton
		#if m_event.pressed:
			#var pos:Vector2 = get_global_mouse_position()
			#if event.button_index == MOUSE_BUTTON_LEFT:
				#Logger.info("Requested shot pos %s" % pos)
				#Events.shoot_requested.emit(pos)				
			#elif event.button_index == MOUSE_BUTTON_RIGHT:
				#Logger.info("Requested thrust pos %s" % pos)
				#Events.thrust_requested.emit()	
		#elif event.button_index == MOUSE_BUTTON_RIGHT:
				#Logger.info("Requested thrust stop " )
				#Events.thrust_stopped.emit()	
			
