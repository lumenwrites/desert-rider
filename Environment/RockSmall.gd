extends Area2D

class_name Trampoline

const SPRITES = [
	preload("res://Environment/sprites/rock_small_01.png"),
	preload("res://Environment/sprites/rock_small_01.png"),
	preload("res://Environment/sprites/rock_small_01.png")
]

export var min_size = 0.5
export var max_size = 1.2

func _ready():
	var size = rand_range(min_size,max_size)
	scale = Vector2(size, size)
	rotation_degrees = rand_range(0, 360)
	var random_texture = int(rand_range(0,SPRITES.size()))
	$Sprite.texture = SPRITES[random_texture]
