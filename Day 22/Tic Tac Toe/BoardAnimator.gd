extends RefCounted

var _grid: GridContainer
var _status_label: Label
var _score_label: Label
var _reset_button: Button
var _owner_node: Node
var _original_grid_pos: Vector2
var _win_particles: CPUParticles2D
var _active_tweens: Array[Tween] = []

const COLOR_X := Color(0.2, 0.6, 1.0)
const COLOR_O := Color(1.0, 0.4, 0.4)
const COLOR_WIN := Color(0.4, 1.0, 0.4)


static func color_for(player: String) -> Color:
	return COLOR_X if player == "X" else COLOR_O


func init(owner: Node, grid: GridContainer, label: Label, score_lbl: Label, reset_btn: Button) -> void:
	_owner_node = owner
	_grid = grid
	_status_label = label
	_score_label = score_lbl
	_reset_button = reset_btn
	_original_grid_pos = grid.position

	_score_label.add_theme_font_size_override("font_size", 22)
	_score_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))

	_win_particles = CPUParticles2D.new()
	_win_particles.emitting = false
	_win_particles.one_shot = true
	_win_particles.amount = 100
	_win_particles.explosiveness = 0.9
	_win_particles.spread = 180.0
	_win_particles.gravity = Vector2(0, 400)
	_win_particles.initial_velocity_min = 200.0
	_win_particles.initial_velocity_max = 500.0
	_win_particles.scale_amount_min = 5.0
	_win_particles.scale_amount_max = 15.0
	_win_particles.lifetime = 1.5
	_win_particles.position = owner.size / 2
	owner.add_child(_win_particles)


func get_button(index: int) -> Button:
	return _grid.get_node("Button" + str(index)) as Button


func animate_place(button: Button, player: String) -> void:
	var p_color := color_for(player)
	button.text = player
	button.add_theme_color_override("font_color", p_color)
	button.modulate.a = 1.0

	var pop_tween := _create_tween()
	button.scale = Vector2(0.5, 0.5)
	pop_tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SPRING)
	pop_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE)

	_shake(5.0, 0.1)
	_spawn_mini_burst(button, p_color)


func clear_button_instant(button: Button) -> void:
	button.text = ""
	button.scale = Vector2(1.0, 1.0)
	button.remove_theme_color_override("font_color")
	button.modulate.a = 1.0


func animate_remove(button: Button) -> void:
	var clear_tween := _create_tween()
	clear_tween.tween_property(button, "scale", Vector2(0.0, 0.0), 0.2).set_trans(Tween.TRANS_BACK)
	clear_tween.tween_callback(func():
		button.text = ""
		button.scale = Vector2(1.0, 1.0)
		button.remove_theme_color_override("font_color")
		button.modulate.a = 1.0
	).set_delay(0.2)


func animate_win(combo: Array, player: String) -> void:
	var p_color := color_for(player)

	_kill_active_tweens()
	for i in range(9):
		get_button(i).modulate.a = 1.0

	_status_label.text = "Player " + player + " wins!"
	_status_label.add_theme_color_override("font_color", COLOR_WIN)

	_shake(20.0, 0.5)

	_win_particles.color = p_color
	_win_particles.emitting = true

	_highlight_win(combo)
	_disable_empty_buttons()

	var label_tween := _create_tween()
	_active_tweens.append(label_tween)
	label_tween.set_loops()
	label_tween.tween_property(_status_label, "scale", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_SINE)
	label_tween.tween_property(_status_label, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE)


func update_score(score_x: int, score_o: int) -> void:
	_score_label.text = "X: " + str(score_x) + "  |  O: " + str(score_o)
	_score_label.pivot_offset = _score_label.size / 2
	var pop := _create_tween()
	pop.tween_property(_score_label, "scale", Vector2(1.3, 1.3), 0.15).set_trans(Tween.TRANS_BACK)
	pop.tween_property(_score_label, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_SINE)


func animate_turn_change(player: String, oldest_blink_index: int) -> void:
	var p_color := color_for(player)

	_kill_active_tweens()

	for i in range(9):
		var btn := get_button(i)
		if btn.text != "":
			btn.modulate.a = 1.0

	_status_label.text = "Player " + player + "'s turn"
	_status_label.add_theme_color_override("font_color", p_color)

	if oldest_blink_index >= 0:
		_animate_blink(get_button(oldest_blink_index))

	var bounce := _create_tween()
	_status_label.position.y -= 10
	bounce.tween_property(_status_label, "position:y", _status_label.position.y + 10, 0.3) \
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)


func animate_reset() -> void:
	_kill_active_tweens()

	var spin := _create_tween()
	spin.tween_property(_reset_button, "rotation", deg_to_rad(360), 0.5).as_relative()

	_win_particles.emitting = false
	_create_tween().tween_property(_status_label, "scale", Vector2(1.0, 1.0), 0.1)
	_status_label.scale = Vector2(1, 1)

	for i in range(9):
		var button := get_button(i)
		if button.text != "":
			var clear_tween := _create_tween()
			clear_tween.tween_property(button, "scale", Vector2(0.0, 0.0), 0.2)
			clear_tween.tween_callback(func():
				_reset_button_visuals(button)
			).set_delay(0.2)
		else:
			_reset_button_visuals(button)


func _reset_button_visuals(button: Button) -> void:
	button.text = ""
	button.scale = Vector2(1.0, 1.0)
	button.disabled = false
	button.remove_theme_color_override("font_color")
	button.modulate.a = 1.0


func _animate_blink(button: Button) -> void:
	var blink_tween := _create_tween()
	_active_tweens.append(blink_tween)
	blink_tween.set_loops()
	blink_tween.tween_property(button, "modulate:a", 0.2, 0.4).set_trans(Tween.TRANS_SINE)
	blink_tween.tween_property(button, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)


func _highlight_win(combo: Array) -> void:
	var win_tween := _create_tween()
	_active_tweens.append(win_tween)
	win_tween.set_loops()
	win_tween.set_parallel(true)

	for i: int in combo:
		var button := get_button(i)
		button.add_theme_color_override("font_color", COLOR_WIN)
		button.modulate.a = 1.0
		win_tween.tween_property(button, "scale", Vector2(1.15, 1.15), 0.5)

	win_tween.chain().set_parallel(true)
	for i: int in combo:
		var button := get_button(i)
		win_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.5)


func _disable_empty_buttons() -> void:
	for i in range(9):
		var button := get_button(i)
		if button.text == "":
			button.disabled = true
			var fade := _create_tween()
			fade.tween_property(button, "modulate:a", 0.3, 0.5)


func _shake(intensity: float, duration: float) -> void:
	var shake_tween := _create_tween()
	var steps := int(duration / 0.05)

	for i in range(steps):
		var offset := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		shake_tween.tween_property(_grid, "position", _original_grid_pos + offset, 0.05)

	shake_tween.tween_property(_grid, "position", _original_grid_pos, 0.05)


func _spawn_mini_burst(button: Button, p_color: Color) -> void:
	var burst := CPUParticles2D.new()
	burst.emitting = false
	burst.one_shot = true
	burst.amount = 15
	burst.explosiveness = 0.8
	burst.spread = 180.0
	burst.gravity = Vector2(0, 100)
	burst.initial_velocity_min = 50.0
	burst.initial_velocity_max = 150.0
	burst.scale_amount_min = 2.0
	burst.scale_amount_max = 5.0
	burst.color = p_color
	burst.lifetime = 0.5
	button.add_child(burst)
	burst.position = button.size / 2
	burst.emitting = true
	_owner_node.get_tree().create_timer(1.0).timeout.connect(burst.queue_free)


func _kill_active_tweens() -> void:
	for tween in _active_tweens:
		if tween and tween.is_valid():
			tween.kill()
	_active_tweens.clear()


func _create_tween() -> Tween:
	return _owner_node.create_tween()
