extends Node2D

const FISH_SCENE=preload("res://src/fish/fish.tscn")
@export
var fish_scenes:Array[PackedScene] 
@export 
var window_size:=Vector2(320,180)
@export
var min_fish_count:=5

var last_position:Vector2 
var init_done := false

@onready var fishes = $Fishes


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Events.player_position_updated.connect(_on_player_position_updated)
	($ParallaxBackground/ParallaxLayer3/AnimatedSprite2D as AnimatedSprite2D).play("default")
	
func _on_player_position_updated(pos:Vector2):
	last_position = pos
	if not init_done:			
		init_done=true

func _select_fish_scene()->PackedScene:	
	return fish_scenes[randi()%fish_scenes.size()]

func _spawn_fish():
	
	var y:float = last_position.y + randf()*window_size.y-window_size.y/2 
	var direction:int = 1 if randf()>.5 else -1
	var x:float = last_position.x + window_size.x/2.0*(1.2 + randf()*.5)*direction
	var f = _select_fish_scene().instantiate()
	fishes.add_child(f)	
	f.global_position=Vector2(x,y)
	f.rotation = -PI if direction == 1 else 0
	Logger.info("Spawned fish %s at %s with rotation %f" % [f.name, f.global_position, f.rotation_degrees] )
	#if direction == -1:
		
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
			


func _on_spawn_timer_timeout():
	if fishes.get_child_count()<min_fish_count:
		_spawn_fish()
