extends Position2D

const BARREL = preload("res://Environment/Barrel.tscn")

export (float) var wait_time = 1
export (float) var distance = 1024 # off screen
export var do_spawn = true

func _ready():
	$Timer.wait_time = wait_time
	
func spawn_barrel():
	var barrel_instance = BARREL.instance()
	var scene_root = get_tree().root.get_children()[0]
	barrel_instance.global_position = global_position
	scene_root.add_child(barrel_instance)

func _on_Timer_timeout():
	if not do_spawn: return
	randomize()
	var random_angle = rand_range(0, 360)
	var random_direction = Vector2(1,0).rotated(deg2rad(random_angle)) * distance
	# Move spawn to a random point on a circle around the player with a radius of distance
	global_position = G.PlayerNode.global_position + random_direction
	spawn_barrel()
