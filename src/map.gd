extends Node2D

const ASTEROID_SCENE=preload("res://src/objects/asteroid.tscn")
const BLACK_HOLE_SCENE=preload("res://src/objects/black_hole.tscn")

@export
var fish_scenes:Array[PackedScene] 
@export 
var window_size:=Vector2(320,180)
@export 
var map_size:=Vector2(1600,900)
@export
var black_hole_count:= 10

@export
var min_fish_count:=5
@export
var asteroid_period:Vector2 = Vector2(1,5)
@export 
var asteroid_distance := Vector2(320,450)

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
	_spawn_black_holes()

func _spawn_black_holes():
	var black_holes:Array = []
	for i in range(black_hole_count):
		for j in range(50):
			var pos:Vector2 = Vector2(map_size.x*randf(),map_size.y*randf())-map_size/2.0
			var valid=true
			for o in black_holes:
				if pos.distance_to(o)< 500:
					valid=false
					break
			if not valid:
				continue
			black_holes.append(pos)
	for p in black_holes:
		var bo = BLACK_HOLE_SCENE.instantiate()
		$Objects.add_child(bo)
		bo.global_position=p
		
func _on_game_over():
	Globals.game_over()
	

func _schedule_asteroid():
	_spawn_asteroid()
	
func _spawn_asteroid():
	var asteroid = ASTEROID_SCENE.instantiate()
	
	var angle = 2*PI*randf()
	asteroid.direction = Vector2.RIGHT.rotated(angle-PI)
	var dist = randf()*(asteroid_distance.y - asteroid_distance.x)+asteroid_distance.x
	$Objects.add_child(asteroid)	
	asteroid.global_position = last_position+ Vector2.RIGHT.rotated(angle)*dist
	Logger.info("last pos %s asteroid %s (dist %2f angle %2f)" % [last_position, asteroid.global_position, dist, rad_to_deg(angle)])
	await get_tree().create_timer(asteroid_period.x + (asteroid_period.y-asteroid_period.x)*randf()).timeout
	_schedule_asteroid()

func _on_player_position_updated(pos:Vector2):
	last_position = pos
	if not init_done:			
		init_done=true
		_schedule_asteroid()

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
