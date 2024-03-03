extends Area2D

const ASTEROID_SCENE=preload("res://src/objects/asteroid.tscn")
const BLACK_HOLE_SCENE=preload("res://src/objects/black_hole.tscn")

const FISH_SCENES = [
	preload("res://src/fish/fish.tscn"),
	preload("res://src/fish/eel.tscn"),
	preload("res://src/fish/little_fish.tscn"),
	preload("res://src/fish/jelly.tscn"),
	preload("res://src/fish/shell.tscn")
]

enum Type {
	Asteroid,
	BlackHole,
	Bubble,
	Fish,
}

@export var max_asteroids: int = 3
@export var asteroid_chance: float = 0.5

@export var max_black_holes: int = 1
@export var black_hole_chance: float = 0.5

@export var max_bubbles: int = 5
@export var bubble_chance: float = 0.5

@export var max_fish: int = 10
@export var fish_chance: float = 0.5

@export var size: Vector2 = Vector2(320, 180)

@export var objects_path: NodePath
@export var fish_path: NodePath


@onready var configs: Dictionary = {
	Type.Asteroid: Config.new(max_asteroids, asteroid_chance),
	Type.BlackHole:  Config.new(max_black_holes, black_hole_chance),
	Type.Bubble:  Config.new(max_bubbles, bubble_chance),
	Type.Fish:  Config.new(max_fish, fish_chance),
}

@onready var objects: Node2D = get_node(objects_path)
@onready var fishes: Node2D = get_node(fish_path)

func _ready():
	if objects == null:
		objects = self
	if fishes == null:
		fishes = self
	

func spawn() -> void:
	var items = count_items()
	for type in items.keys():
		var config = configs[type]
		if configs[type].should_spawn(items[type]):
			spawn_item(type)
	

func spawn_item(type: Type) -> void:
	match(type):
		Type.Asteroid:
			spawn_asteroid()
		Type.Fish:
			spawn_fish()
		
	

func spawn_asteroid() -> void:
	var asteroid = ASTEROID_SCENE.instantiate()
	asteroid.global_position = global_position + random_position()
	asteroid.rotation = random_angle()
	asteroid.direction = Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
	
	objects.add_child(asteroid)
	asteroid.setup(randi_range(0, 1) , randi_range(0, 1))
	Logger.debug("Spawned asteroid at %s" % asteroid.global_position)
	

func spawn_fish() -> void:
	var fish = FISH_SCENES[randi()%FISH_SCENES.size()].instantiate()
	fish.global_position = global_position + random_position()
	fish.rotation = random_angle()
	
	fishes.add_child(fish)
	Logger.debug("Spawned fish at %s" % fish.global_position)
	

func random_position() -> Vector2:
	return Vector2(randi_range(0, size.x), randi_range(0, size.y))
	

func random_angle() -> float:
	return randi_range(0, 3) * PI / 2
	

func count_items() -> Dictionary:
	var count: Dictionary = {
		Type.Asteroid: 0,
		Type.BlackHole: 0,
		Type.Bubble: 0,
		Type.Fish: 0,
	}
	
	for item in get_overlapping_areas():
		if item is BlackHole:
			count[Type.BlackHole] += 1
		elif item is Bubble:
			count[Type.Bubble] += 1
		elif item.owner is Fish:
			count[Type.Fish] += 1
		else:
			Logger.warn("Unknown area in spawner")
			 
	
	for item in get_overlapping_bodies():
		if item is Asteroid:
			count[Type.Asteroid] += 1
		elif item is BlackHole:
			count[Type.BlackHole] += 1
		elif item is Bubble:
			count[Type.Bubble] += 1
		elif item is Fish:
			count[Type.Fish] += 1
		else:
			Logger.warn("Unknown body in spawner")
	
	return count
	

func _on_timer_timeout():
	spawn()


class Config:
	var max_items: int
	var spawn_chance: float
	
	func _init(max: int, chance: float) -> void:
		max_items = max
		spawn_chance = chance
	
	func should_spawn(current_items: int) -> bool:
		if current_items < max_items:
			if randf() < spawn_chance:
				return true
			
		return false
		
