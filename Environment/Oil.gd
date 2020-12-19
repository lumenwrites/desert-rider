extends Area2D

export var min_size = 0.5
export var max_size = 2
export var spill = false

func _ready():
	var size = rand_range(min_size,max_size)
	scale = Vector2(size, size)
	rotation_degrees = rand_range(0, 360)
	if spill:
		$AnimationPlayer.play("spill")
