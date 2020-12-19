extends Area2D

class_name Vehicle

export (float) var speed = 80
export (float) var friction = 0.87
export (float) var steer_force = 70
var vel = Vector2()
var speed_modifier = 1.0 # for oil and boosts

func _ready():
	# Make sure it's above the rocks
	z_index = 5
	
func _physics_process(delta):
	# Overriden by child classes (Player.gd and Enemy.gd)
	pass
	
func steer(target, desired_distance, delta):
	var target_direction = global_position.direction_to(target)
	var current_direction = transform.x # vel.normalized()
	if global_position.distance_to(target) > desired_distance:
		vel += lerp(current_direction, target_direction, steer_force*delta).normalized() * speed * speed_modifier
	vel *= friction
	position += vel * delta
	rotation = vel.angle()

func _on_Vehicle_area_entered(area):
	explode()
	
func explode():
	# disable collisions
	set_collision_layer_bit(0,false)
	set_collision_mask_bit(0, false)
	set_monitoring(false)
	# stop moving
	speed = 0
	vel = Vector2.ZERO
	# hide sprites
	for child in get_children():
		if child is Sprite: child.hide()
	# Show and play explosion animation	
	$AnimatedSprite.show()
	$AnimatedSprite.play()
	# Play explosion sound
	$AudioStreamPlayer2D.stream = load("res://sounds/explosion.wav")
	$AudioStreamPlayer2D.play()

func _on_AudioStreamPlayer2D_finished():
	# After it's finished playing, enemy cars will queue_free(), if player exploded it'll restart the game
	# (overriden in Enemy.gd and Player.gd)
	pass


func _on_Vehicle_area_exited(area):
	if area.is_in_group("Oil"):
		speed_modifier = 1.0


func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
