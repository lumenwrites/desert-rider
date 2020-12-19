extends Position2D

const ENEMY = preload("res://Vehicles/Enemy.tscn")

export (float) var wait_time = 2
export (float) var distance = 2000 # off screen
export var do_spawn = true

func _ready():
	$Timer.wait_time = wait_time
	
func spawn_enemy():
	var enemy_instance = ENEMY.instance()
	# var scene_root = get_tree().root.get_children()[0]
	enemy_instance.global_position = global_position
	$"../EnemyCars".add_child(enemy_instance)	

func _on_Timer_timeout():
	if not do_spawn: return
	randomize()
	var random_angle = rand_range(0, 360)
	# Unit vector, rotated by a random angle, multiplied by distance
	# Will point to a random point on a circle with a radius of distance
	var random_direction = Vector2(1,0).rotated(deg2rad(random_angle)) * distance
	# Move spawn to a random point on a circle around the player with a radius of distance
	global_position = G.PlayerNode.global_position + random_direction
	spawn_enemy()
	
	# Spawn enemies faster
	if $Timer.wait_time > 0.3:
		$Timer.wait_time -= $Timer.wait_time * 0.03
