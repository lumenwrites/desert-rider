extends Vehicle

class_name Enemy

func _physics_process(delta):
	if not G.PlayerNode.dead: # if player hasn't been killed yet
		var target = G.PlayerNode.global_position
		steer(target, 0, delta)

func _on_Vehicle_area_entered(area):
	if area.is_in_group("Oil"):
		speed_modifier = 0.1
		return
	if area.is_in_group("Barrel"):
		area.queue_free()
		explode()
		return
	# Reward player with extra points if he drives a car into rocks or into another car
	# Cars are bad at evading rocks, and keep exploding off screen, don't want to give points for that
	# So I reward points only when a car explodes on screen
	# And of course I don't reward ponits if car explodes against the player
	# or if it explodes after player has died
	var distance_to_player = global_position.distance_to(G.PlayerNode.global_position)
	if not G.PlayerNode.dead and not area is Player and distance_to_player < 1024: # area.is_in_group("Enemies"):
		G.HUDNode.current_score += 10
		G.HUDNode.update_score_labels()
	explode()
	
func _on_AudioStreamPlayer2D_finished():
	queue_free()
