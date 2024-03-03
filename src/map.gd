extends Node2D

const ASTEROID_SCENE=preload("res://src/objects/asteroid.tscn")
@export
var fish_scenes:Array[PackedScene] 
@export 
var window_size:=Vector2(320,180)
@export
var min_fish_count:=5
@export
var asteroid_period:Vector2 = Vector2(1,5)
@export 
var asteroid_distance := Vector2(320,500)

var last_position:Vector2 
var init_done := false

@onready var fishes = $Fishes


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Events.player_position_updated.connect(_on_player_position_updated)
	Events.oxygen_out.connect(_on_game_over)
	Events.game_over.connect(_on_game_over)
	#($ParallaxBackground/ParallaxLayer3/AnimatedSprite2D as AnimatedSprite2D).play("default")
	
func _on_game_over():
	Globals.game_over()
	

func _schedule_asteroid():
	_spawn_asteroid()
	
func _spawn_asteroid():
	var asteroid = ASTEROID_SCENE.instantiate()
	
	var angle = 2*PI*randf()
	#asteroid.direction = Vector2.RIGHT.rotated(angle-PI)
	var dist = randf()*(asteroid_distance.y - asteroid_distance.x)+asteroid_distance.x
	$Objects.add_child(asteroid)	
	asteroid.global_position = last_position+ Vector2.RIGHT.rotated(angle)*dist
	Logger.info("last pos %s asteroid %s (dist %2f angle %2f)" % [last_position, asteroid.global_position, dist, rad_to_deg(angle)])
	

func _on_player_position_updated(pos:Vector2):
	last_position = pos
	if not init_done:			
		init_done=true
		#_schedule_asteroid()

func _select_fish_scene()->PackedScene:	
	return fish_scenes[randi()%fish_scenes.size()]

func _spawn_fish():
	
	var y:float = last_position.y + randf()*window_size.y-window_size.y/2 
	var direction:int = 1 if randf()>.5 else -1
	var x:float = last_position.x + window_size.x/2.0*(1.2 + randf()*.5)*direction
	var f = _select_fish_scene().instantiate()
	fishes.add_child(f)	
	f.global_position=Vector2(x,y)
	f.rotation = -PI if direction == 1 else 0.0
	Logger.info("Spawned fish %s at %s with rotation %f" % [f.name, f.global_position, f.rotation_degrees] )
	#if direction == -1:
		


func _on_spawn_timer_timeout():
	if fishes.get_child_count()<min_fish_count:
		_spawn_fish()
