extends Control

var current_player = "X"
var board = ["", "", "", "", "", "", "", "", ""]
var game_over = false

@onready var status_label = $StatusLabel
@onready var grid_container = $GridContainer
@onready var reset_button = $ResetButton

# Define colors for QoL
var color_x = Color(0.2, 0.6, 1.0) # Light blue
var color_o = Color(1.0, 0.4, 0.4) # Light red
var color_win = Color(0.4, 1.0, 0.4) # Light green
var color_draw = Color(0.7, 0.7, 0.7) # Gray
var color_default = Color(1.0, 1.0, 1.0) # White

func _ready():
	# Connect signals for grid buttons
	for i in range(9):
		var button = grid_container.get_node("Button" + str(i))
		button.pressed.connect(_on_button_pressed.bind(i))
		button.custom_minimum_size = Vector2(100, 100)
		# Ensure font size is reasonably large
		button.add_theme_font_size_override("font_size", 48)

	# Connect reset button
	reset_button.pressed.connect(reset_game)
	status_label.add_theme_font_size_override("font_size", 24)
	update_status()

func _on_button_pressed(index):
	if game_over or board[index] != "":
		return

	board[index] = current_player
	var button = grid_container.get_node("Button" + str(index))
	button.text = current_player

	# Set button text color based on player
	if current_player == "X":
		button.add_theme_color_override("font_color", color_x)
	else:
		button.add_theme_color_override("font_color", color_o)

	var win_combo = check_win()
	if win_combo.size() > 0:
		status_label.text = "Player " + current_player + " wins!"
		status_label.add_theme_color_override("font_color", color_win)
		game_over = true
		highlight_win(win_combo)
		disable_empty_buttons()
	elif check_draw():
		status_label.text = "It's a draw!"
		status_label.add_theme_color_override("font_color", color_draw)
		game_over = true
	else:
		if current_player == "X":
			current_player = "O"
		else:
			current_player = "X"
		update_status()

func update_status():
	status_label.text = "Player " + current_player + "'s turn"
	if current_player == "X":
		status_label.add_theme_color_override("font_color", color_x)
	else:
		status_label.add_theme_color_override("font_color", color_o)

func check_win() -> Array:
	# Winning combinations
	var win_combos = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8], # Horizontal
		[0, 3, 6], [1, 4, 7], [2, 5, 8], # Vertical
		[0, 4, 8], [2, 4, 6]             # Diagonal
	]

	for combo in win_combos:
		var a = combo[0]
		var b = combo[1]
		var c = combo[2]

		if board[a] != "" and board[a] == board[b] and board[a] == board[c]:
			return combo

	return []

func highlight_win(combo):
	for i in combo:
		var button = grid_container.get_node("Button" + str(i))
		button.add_theme_color_override("font_color", color_win)

func disable_empty_buttons():
	for i in range(9):
		var button = grid_container.get_node("Button" + str(i))
		if board[i] == "":
			button.disabled = true

func check_draw():
	for cell in board:
		if cell == "":
			return false
	return true

func reset_game():
	current_player = "X"
	board = ["", "", "", "", "", "", "", "", ""]
	game_over = false

	for i in range(9):
		var button = grid_container.get_node("Button" + str(i))
		button.text = ""
		button.disabled = false
		button.remove_theme_color_override("font_color")

	update_status()
