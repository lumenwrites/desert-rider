extends Node2D

var player_pos = Vector2()
# player position in integers
var px = 0
var py = 0
var chunk_size = 1024
var current_chunk = [0,0]
export var custom_seed = 12

func _ready():
	player_pos = G.PlayerNode.global_position
	px = int(player_pos.x) / chunk_size
	py = int(player_pos.y) / chunk_size 
	spawn_adjacent_chunks(px,py)

func _physics_process(delta):
	update_chunks()
	
func update_chunks():
	player_pos = G.PlayerNode.global_position
	px = int(player_pos.x) / chunk_size
	py = int(player_pos.y) / chunk_size 
	# Negative numbers are rounded up differently, this is a hacky fix
	if player_pos.x < 0: px -= 1
	if player_pos.y < 0: py -= 1	
	if current_chunk != [px,py]:
		delete_chunks()
		spawn_adjacent_chunks(px,py)
	current_chunk = [px,py]
	
const CHUNK = preload("res://Environment/Chunk.tscn")
func delete_chunks():
	for chunk in get_children():
		chunk.queue_free()
		
func spawn_adjacent_chunks(px,py):
	for cx in range(px-1,px+2):
		for cy in range(py-1, py+2):
			spawn_chunk(cx,cy)
	
func spawn_chunk(px,py):
	var chunk_instance = CHUNK.instance()
	chunk_instance.global_position.x = px * chunk_size
	chunk_instance.global_position.y = py * chunk_size
	# Unique seed for each chunk based on position
	# Multiply py by 10 because px+py = py+px, so diagonal chunks were the same
	chunk_instance.current_seed = px+py*10+custom_seed
	chunk_instance.chunk_size = chunk_size
#	seed(px+py)
	# chunk_instance.get_children()[2].text = str(randi())
	add_child(chunk_instance)
