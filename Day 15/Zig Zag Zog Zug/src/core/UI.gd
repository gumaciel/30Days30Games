extends Control

var score := 0 setget set_score 
var high_score := 0 setget set_high_score


func _ready():
	load_game()

func set_score(value: int):
	score = value
	if score > high_score:
		self.high_score = score
	$VBoxContainer/Score.text = "Score: " + str(score)

func set_high_score(value : int):
	high_score = value
	save_game()
	$VBoxContainer/Highscore.text = "Highscore: " + str(high_score)

func save_game():
	var save_game = File.new()
	var save = call("save")
	save_game.open("user://savegame.save", File.WRITE)
	var node_data = call("save")
	save_game.store_line(to_json(node_data))
	save_game.close()
 
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		self.high_score = node_data["high_score"]



func save():
	var save_dict = {
		"high_score" : high_score
	}
	return save_dict
	
func _on_Ball_points_changed(value):
	$VBoxContainer/Score.text = "Score: " + str(value)
	self.score = value
