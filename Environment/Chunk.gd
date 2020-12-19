extends Node2D

const ROCK_SMALL = preload("res://Environment/RockSmall.tscn")
const ROCK_BIG = preload("res://Environment/RockBig.tscn")
const OIL = preload("res://Environment/Oil.tscn")

export var number_of_rocks = 3
# Set by Chunks.gd
var chunk_size = 1024
var current_seed = 0

func _ready():
	seed(current_seed)
	$TextureRect.rect_size.x = chunk_size
	$TextureRect.rect_size.y = chunk_size
	scatter_rocks()
	
	
func scatter_rocks():
	for rock in range(number_of_rocks):
		var position = Vector2(rand_range(0, chunk_size),rand_range(0, chunk_size))
		var random = randf()
		if random < 0.3: # 30% chance to spawn big rock
			spawn(position, ROCK_BIG)
		elif random < 0.7: # 40% chance to spawn small rock
			spawn(position, ROCK_SMALL)
		else: # 20% chance to spawn oil
			spawn(position, OIL)


func spawn(position, rock_type):
	var rock_instance = rock_type.instance()
	rock_instance.position = position
	add_child(rock_instance)
