@tool
extends HBoxContainer

@export 
var texture: Texture2D:
	set(value):
		texture = value
		_create_textures()
	

@export
var texture_padding: int = 1:
	set(value):
		texture_padding = value
		_create_textures()
	

@export 
var padding: int = 0:
	set(value):
		padding = value
		_update()
	

@export
var number: int:
	set(value):
		number = value
		_update()
	

var textures: Array[Texture2D]


func _ready() -> void:
	_create_textures()
	_update()
	

func _update() -> void:
	for child in get_children():
		child.queue_free()
	
	var text = "%*d" % [padding, number]
	for letter in text:
		if letter == " ":
			_add_space()
		else:
			_add_number(int(letter))
	

func _add_space() -> void:
	var space = Control.new()
	space.custom_minimum_size = textures.front().get_size()
	add_child(space)
	

func _add_number(number: int) -> void:
	var rect = TextureRect.new()
	rect.texture = textures[number - 1]
	add_child(rect)
	

func _create_textures() -> void:
	if texture == null:
		return
	
	textures.clear()
	
	var height = texture.get_height()
	var width = (texture.get_width() + texture_padding) / 10
	 
	for i in range(0,10):
		var number_texture = AtlasTexture.new()
		number_texture.atlas = texture
		number_texture.region = Rect2(i * width, 0, width - texture_padding, height)
		textures.append(number_texture)
