extends Control

var current_player = "X"
var board = ["", "", "", "", "", "", "", "", ""]
var game_over = false

@onready var status_label = $StatusLabel
@onready var grid_container = $GridContainer
@onready var reset_button = $ResetButton

func _ready():
	# Connect signals for grid buttons
	for i in range(9):
		var button = grid_container.get_node("Button" + str(i))
		button.pressed.connect(func(): _on_button_pressed(i))
		button.custom_minimum_size = Vector2(100, 100)

	# Connect reset button
	reset_button.pressed.connect(reset_game)
	update_status()

func _on_button_pressed(index):
	if game_over or board[index] != "":
		return

	board[index] = current_player
	var button = grid_container.get_node("Button" + str(index))
	button.text = current_player

	if check_win():
		status_label.text = "Player " + current_player + " wins!"
		game_over = true
	elif check_draw():
		status_label.text = "It's a draw!"
		game_over = true
	else:
		if current_player == "X":
			current_player = "O"
		else:
			current_player = "X"
		update_status()

func update_status():
	status_label.text = "Player " + current_player + "'s turn"

func check_win():
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
			return true

	return false

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

	update_status()
