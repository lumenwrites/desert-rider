extends Node

var save_data = {
	"max_score": 0
}
const SAVE_GAME = "user://RiderSaveGame.json"

func _ready():
	# Load data when opening the game
	save_data = load_game()
	
func load_game():
	var file = File.new()
	if not file.file_exists(SAVE_GAME):
		# Create file if it doesn't exists - save default values into it
		save_data = {"max_score": 0}
		save_game()
	file.open(SAVE_GAME, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	save_data = data
	file.close()
	return data
	
func save_game():
	# Put save_data into file
	var file = File.new()
	file.open(SAVE_GAME, File.WRITE)
	file.store_line(to_json(save_data))
	file.close()
