extends Node2D

var max_dist = 1000 # 
var min_dist = 300

func _physics_process(delta):
	var player_dir = G.PlayerNode.global_position - global_position
	if player_dir.length() > max_dist or  player_dir.length() < min_dist:
		hide()
		return
	show()
	look_at(G.PlayerNode.global_position)
	$Sprite.position.x = player_dir.length() - 300
	var arrow_scale = range_lerp(player_dir.length(), min_dist, max_dist, 2, 0)
	$Sprite.scale = Vector2(arrow_scale, arrow_scale)
