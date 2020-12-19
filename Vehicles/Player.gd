extends Vehicle

class_name Player

const OIL = preload("res://Environment/Oil.tscn")

var dead = false
var pickups = 3

func _ready():
	G.PlayerNode = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_custom_mouse_cursor(
		load("res://GUI/sprites/crossair_black.png"),
		Input.CURSOR_ARROW, Vector2(16,16)
	)
	
	
func _physics_process(delta):
	if dead: return
	var target = get_global_mouse_position()
	# var target = $MobileCursorPosition.global_position
	steer(target, 20, delta)
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if dead: return
	if Input.is_action_just_pressed("left_click"):
		boost() 
	if Input.is_action_just_pressed("right_click"):
		spawn_oil()
	if Input.is_action_just_pressed("middle_click"):
		jump()

func spawn_oil():
	if pickups > 0:
		pickups -= 1
		G.HUDNode.update_score_labels()
		
		var oil_instance = OIL.instance()
		var scene_root = get_tree().root.get_children()[0]
		oil_instance.global_transform = $SpawnOil.global_transform
		oil_instance.min_size = 2.5
		oil_instance.max_size = 2.5
		oil_instance.spill = true
		scene_root.add_child(oil_instance)

func boost():
	if pickups > 0:
		pickups -= 1
		G.HUDNode.update_score_labels()
		$Flame.show()
		$Flame/AnimationPlayer.play("burn")
		speed_modifier = 2.0
		yield(get_tree().create_timer(1.5), "timeout") 
		speed_modifier = 1.0
		$Flame.hide()

func jump():
	if pickups > 0:
		pickups -= 1
		$AnimationPlayer.play("jump")
	#	$AudioStreamPlayer2D.stream = load()
	#	$AudioStreamPlayer2D.play()
		set_collision_layer_bit(0,false)
		set_collision_mask_bit(0, false)
		steer_force *= 0.1
		speed_modifier *= 1.5
	
func _on_Vehicle_area_entered(area):
	if area.is_in_group("Oil"):
		speed_modifier = 0.2
	if area.is_in_group("Barrel"):
		pickups += 1
		area.queue_free()
		G.HUDNode.update_score_labels()
		# Add a bonus for picking up a barrel
		G.HUDNode.current_score += 20
		G.HUDNode.update_score_labels()
	if area.is_in_group("Enemies") or area.is_in_group("BigRocks"):
		die()
	if area.is_in_group("SmallRocks"):
		jump()

func die():
	dead = true # used in hud  and in Enemy.gd to stop increasing score
	explode()	
	


func _on_AnimationPlayer_animation_finished(anim_name):
	set_collision_layer_bit(0,true)
	set_collision_mask_bit(0, true)
	steer_force /= 0.1
	speed_modifier /= 1.5
	
func _on_AnimatedSprite_animation_finished():
	if dead: get_tree().change_scene("res://Environment/World.tscn")



