extends Node


const GAMEOVER = "res://src/game_over.tscn"
const START = "res://src/start_screen.tscn"
const MAP = "res://src/map.tscn"


var master_volume:float = 100
var music_volume:float = 100
var sfx_volume:float = 100

const GameDataPath = "user://conf.cfg"
var config:ConfigFile

var debug_build := false
var music


var score: int = 0
var alive: bool = true


func _ready():
	_init_logger()	
	Logger.info("Logger initialized.")
	Events.fish_captured.connect(_on_fish_captured)
	

func start() -> void:
	Logger.info("start game")
	score = 0
	alive = true
	SceneManager.change_scene(MAP)
	

func game_over() -> void:
	if not alive:
		return
	
	Logger.info("game over")
	alive = false
	SceneManager.change_scene(GAMEOVER)
	
func _force_angle_precision(angle: float, precision: float) -> float:
	return precision * round(angle / precision)
	

func _init_logger():
	Logger.set_logger_level(Logger.LOG_LEVEL_INFO)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var console_appender:Appender = Logger.add_appender(ConsoleAppender.new())
	console_appender.logger_format=Logger.LOG_FORMAT_FULL
	console_appender.logger_level = Logger.LOG_LEVEL_DEBUG
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_DEBUG


func _on_fish_captured(_fish: Fish) -> void:
	score += 1
	Events.score_changed.emit(score)

