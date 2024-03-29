extends TextureProgressBar


@export var max_oxygen: int = 200
@export var alert_factor: float = 0.3

@onready var alarm = $AlarmSound


func _ready() -> void:
	max_value = max_oxygen
	value = max_oxygen
	Events.oxygen_consumed.connect(_on_oxygen_consumed)
	Events.oxygen_restored.connect(_on_oxygen_restored)
	

func start_alarm() -> void:
	Logger.info("oxygen low")
	alarm.play()
	

func stop_alarm() -> void:
	Logger.info("oxygen recuperated")
	alarm.stop()
	

func _on_oxygen_consumed(delta: int) -> void:
	value = clampi(value - delta, 0, max_oxygen)
	
	if not alarm.playing and value <= (max_oxygen * alert_factor):
		start_alarm() 
		
	if value <= 0:
		Logger.info("oxygen out")
		Events.oxygen_out.emit()
	

func _on_oxygen_restored(delta: int) -> void:
	value = clampi(value + delta, 0, max_oxygen)
	
	if alarm.playing and value >= (max_oxygen * alert_factor):
		start_alarm() 
	
