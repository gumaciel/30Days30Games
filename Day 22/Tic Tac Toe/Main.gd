extends Control

var current_player: String = "X"
var board: Array[String] = ["", "", "", "", "", "", "", "", ""]
var game_over: bool = false

# Track moves for the non-stop variant
var moves_x: Array[int] = []
var moves_o: Array[int] = []

@onready var status_label: Label = $StatusLabel
@onready var grid_container: GridContainer = $GridContainer
@onready var reset_button: Button = $ResetButton

# Define colors for QoL
var color_x := Color(0.2, 0.6, 1.0) # Light blue
var color_o := Color(1.0, 0.4, 0.4) # Light red
var color_win := Color(0.4, 1.0, 0.4) # Light green
var color_default := Color(1.0, 1.0, 1.0) # White

# Original positions for shake effect
var original_grid_pos: Vector2

# Particles for celebration
var win_particles: CPUParticles2D

# Store looping tweens to kill them on reset
var active_tweens: Array[Tween] = []

func _ready() -> void:
	# Store initial position
	original_grid_pos = grid_container.position

	# Create particles
	win_particles = CPUParticles2D.new()
	win_particles.emitting = false
	win_particles.one_shot = true
	win_particles.amount = 100
	win_particles.explosiveness = 0.9
	win_particles.spread = 180.0
	win_particles.gravity = Vector2(0, 400)
	win_particles.initial_velocity_min = 200.0
	win_particles.initial_velocity_max = 500.0
	win_particles.scale_amount_min = 5.0
	win_particles.scale_amount_max = 15.0
	win_particles.lifetime = 1.5
	win_particles.position = size / 2 # Center of screen
	add_child(win_particles)

	# Configure buttons
	for i in range(9):
		var button: Button = grid_container.get_node("Button" + str(i)) as Button
		button.pressed.connect(_on_button_pressed.bind(i))
		button.custom_minimum_size = Vector2(100, 100)
		button.add_theme_font_size_override("font_size", 48)
		# Set pivot offset to center for scaling animation
		button.pivot_offset = Vector2(50, 50)

	# Connect reset button
	reset_button.pressed.connect(reset_game)
	reset_button.pivot_offset = reset_button.size / 2
	status_label.add_theme_font_size_override("font_size", 32)
	status_label.pivot_offset = status_label.size / 2

	update_status()

func _on_button_pressed(index: int) -> void:
	if game_over or board[index] != "":
		return

	# Check if we are making the 3rd move (which will remove the 1st after placement if no win)
	var p_moves := moves_x if current_player == "X" else moves_o
	var removing_index: int = -1

	if p_moves.size() == 3:
		removing_index = p_moves[0]

	# Place piece
	board[index] = current_player
	p_moves.append(index)
	var button: Button = grid_container.get_node("Button" + str(index)) as Button
	button.text = current_player

	# Pop animation for the placed piece
	var pop_tween := create_tween()
	button.scale = Vector2(0.5, 0.5)
	button.modulate.a = 1.0 # Ensure fully visible
	pop_tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SPRING)
	pop_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE)

	# Subtle screen shake on placement
	shake(5.0, 0.1)

	# Set button text color based on player
	var p_color := color_x if current_player == "X" else color_o
	button.add_theme_color_override("font_color", p_color)

	# Pulse particle burst from the button
	var mini_burst := CPUParticles2D.new()
	mini_burst.emitting = false
	mini_burst.one_shot = true
	mini_burst.amount = 15
	mini_burst.explosiveness = 0.8
	mini_burst.spread = 180.0
	mini_burst.gravity = Vector2(0, 100)
	mini_burst.initial_velocity_min = 50.0
	mini_burst.initial_velocity_max = 150.0
	mini_burst.scale_amount_min = 2.0
	mini_burst.scale_amount_max = 5.0
	mini_burst.color = p_color
	mini_burst.lifetime = 0.5
	# Add it, trigger it, then queue_free
	button.add_child(mini_burst)
	mini_burst.position = button.size / 2
	mini_burst.emitting = true
	get_tree().create_timer(1.0).timeout.connect(mini_burst.queue_free)

	# Check for win immediately after placing
	var win_combo := check_win()
	if win_combo.size() > 0:
		handle_win(win_combo, p_color)
		return

	# If no win and we had 3 moves before placing this one (meaning we now have 4),
	# remove the oldest move
	if p_moves.size() == 4:
		var oldest_index: int = p_moves.pop_front()
		board[oldest_index] = ""
		var old_button: Button = grid_container.get_node("Button" + str(oldest_index)) as Button

		# Animate shrinking and clearing
		var clear_tween := create_tween()
		clear_tween.tween_property(old_button, "scale", Vector2(0.0, 0.0), 0.2).set_trans(Tween.TRANS_BACK)
		clear_tween.tween_callback(func():
			old_button.text = ""
			old_button.scale = Vector2(1.0, 1.0)
			old_button.remove_theme_color_override("font_color")
			old_button.modulate.a = 1.0
		).set_delay(0.2)

		# Now check win again in case removing the piece caused the *other* player to win?
		# (In Tic Tac Toe removing your own piece can't make the other player win, but just in case)
		win_combo = check_win()
		if win_combo.size() > 0:
			# Get the winner (might be the other player if logic was weird, but it's not)
			var winner: String = board[win_combo[0]]
			var w_color := color_x if winner == "X" else color_o
			handle_win(win_combo, w_color)
			return

	# Switch turn
	if current_player == "X":
		current_player = "O"
	else:
		current_player = "X"
	update_status()

func handle_win(win_combo: Array, p_color: Color) -> void:
	var winner_name: String = board[win_combo[0]]
	status_label.text = "Player " + winner_name + " wins!"
	status_label.add_theme_color_override("font_color", color_win)
	game_over = true

	# Massive screen shake
	shake(20.0, 0.5)

	# Explode particles in the center
	win_particles.color = p_color
	win_particles.emitting = true

	highlight_win(win_combo)
	disable_empty_buttons()

	# Animate status label
	var win_tween := create_tween()
	active_tweens.append(win_tween)
	win_tween.set_loops()
	win_tween.tween_property(status_label, "scale", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_SINE)
	win_tween.tween_property(status_label, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE)

func update_status() -> void:
	status_label.text = "Player " + current_player + "'s turn"
	var current_color := color_x if current_player == "X" else color_o
	status_label.add_theme_color_override("font_color", current_color)

	# Stop all active tweens to clear previous blinking
	for tween in active_tweens:
		if tween and tween.is_valid():
			tween.kill()
	active_tweens.clear()

	# Restore alpha for all buttons in case they were blinking
	for i in range(9):
		var btn: Button = grid_container.get_node("Button" + str(i)) as Button
		if btn.text != "":
			btn.modulate.a = 1.0

	# Check if the current player has 3 pieces placed (meaning next play will remove the oldest)
	var p_moves := moves_x if current_player == "X" else moves_o
	if p_moves.size() == 3:
		# Make the oldest piece blink
		var oldest_index: int = p_moves[0]
		var blink_btn: Button = grid_container.get_node("Button" + str(oldest_index)) as Button

		var blink_tween := create_tween()
		active_tweens.append(blink_tween)
		blink_tween.set_loops()
		blink_tween.tween_property(blink_btn, "modulate:a", 0.2, 0.4).set_trans(Tween.TRANS_SINE)
		blink_tween.tween_property(blink_btn, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)

	# Little bounce when turn changes
	var bounce := create_tween()
	status_label.position.y -= 10
	bounce.tween_property(status_label, "position:y", status_label.position.y + 10, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func check_win() -> Array:
	# Winning combinations
	var win_combos: Array = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8], # Horizontal
		[0, 3, 6], [1, 4, 7], [2, 5, 8], # Vertical
		[0, 4, 8], [2, 4, 6]             # Diagonal
	]

	for combo in win_combos:
		var a: int = combo[0]
		var b: int = combo[1]
		var c: int = combo[2]

		if board[a] != "" and board[a] == board[b] and board[a] == board[c]:
			return combo

	return []

func highlight_win(combo: Array) -> void:
	var win_tween := create_tween()
	active_tweens.append(win_tween)
	win_tween.set_loops()
	win_tween.set_parallel(true)

	for i in combo:
		var button: Button = grid_container.get_node("Button" + str(i)) as Button
		button.add_theme_color_override("font_color", color_win)
		button.modulate.a = 1.0 # Ensure it's not blinking
		# Pulse the winning buttons
		win_tween.tween_property(button, "scale", Vector2(1.15, 1.15), 0.5)

	# After parallel expansion, add chain for contraction
	win_tween.chain().set_parallel(true)
	for i in combo:
		var button: Button = grid_container.get_node("Button" + str(i)) as Button
		win_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.5)

func disable_empty_buttons() -> void:
	for i in range(9):
		var button: Button = grid_container.get_node("Button" + str(i)) as Button
		if board[i] == "":
			button.disabled = true
			# Fade out empty buttons slightly
			var fade := create_tween()
			fade.tween_property(button, "modulate:a", 0.3, 0.5)

func shake(intensity: float, duration: float) -> void:
	var shake_tween := create_tween()
	var steps := int(duration / 0.05)

	for i in range(steps):
		var random_offset := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		shake_tween.tween_property(grid_container, "position", original_grid_pos + random_offset, 0.05)

	shake_tween.tween_property(grid_container, "position", original_grid_pos, 0.05)

func reset_game() -> void:
	# Kill active looping tweens
	for tween in active_tweens:
		if tween and tween.is_valid():
			tween.kill()
	active_tweens.clear()

	# Add a spin animation to reset button
	var spin := create_tween()
	spin.tween_property(reset_button, "rotation", deg_to_rad(360), 0.5).as_relative()

	current_player = "X"
	board = ["", "", "", "", "", "", "", "", ""]
	moves_x.clear()
	moves_o.clear()
	game_over = false

	# Stop all particles
	win_particles.emitting = false

	# Reset status label scale and color
	create_tween().tween_property(status_label, "scale", Vector2(1.0, 1.0), 0.1)
	status_label.scale = Vector2(1,1)

	for i in range(9):
		var button: Button = grid_container.get_node("Button" + str(i)) as Button

		# Animate clear
		if button.text != "":
			var clear_tween := create_tween()
			clear_tween.tween_property(button, "scale", Vector2(0.0, 0.0), 0.2)
			clear_tween.tween_callback(func():
				button.text = ""
				button.scale = Vector2(1.0, 1.0)
				button.disabled = false
				button.remove_theme_color_override("font_color")
				button.modulate.a = 1.0
			).set_delay(0.2)
		else:
			button.disabled = false
			button.remove_theme_color_override("font_color")
			button.modulate.a = 1.0
			button.scale = Vector2(1.0, 1.0)

	# Wait for clear animation before updating status text
	await get_tree().create_timer(0.25).timeout
	update_status()
