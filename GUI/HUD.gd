extends CanvasLayer

var current_score = 0
var max_score = 0


func _ready():
	G.HUDNode = self
	update_score_labels()
	$Help/AnimationPlayer.play("fade")
	
func update_score_labels(): # Also used to update score when enemy explodes
	$PickupsLabel.set_text("%d" % [G.PlayerNode.pickups])
	$HBox/ScoreLabel.set_text("%d" % [current_score])
	# Letters in the font have different widths, and that causes the MaxScore part of the string to wobble
	# So I change the size of the score label based on the number of digits
	$HBox/ScoreLabel.rect_min_size.x = str(current_score).length() * 16 # (current_score / 10) * 24
	$HBox/MaxScoreLabel.set_text("| %d" % [Save.save_data.max_score])	
	
func _on_Timer_timeout():
	if not G.PlayerNode.dead:
		current_score += 1
		update_score_labels()
	else:
		if current_score > Save.save_data.max_score:
			Save.save_data.max_score = current_score
			update_score_labels()
			Save.save_game()
