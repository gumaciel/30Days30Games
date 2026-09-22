extends Control

const BoardState := preload("res://BoardState.gd")
const BoardAnimator := preload("res://BoardAnimator.gd")

@onready var safe_area: MarginContainer = $SafeArea
@onready var ui: Control = $SafeArea/UI
@onready var status_label: Label = $SafeArea/UI/StatusLabel
@onready var score_label: Label = $SafeArea/UI/ScoreLabel
@onready var grid_container: GridContainer = $SafeArea/UI/GridContainer
@onready var reset_button: Button = $SafeArea/UI/ResetButton

var _state: RefCounted
var _animator: RefCounted

var _fps_label: Label


var _fps_timer := 0.0
func _process(delta: float) -> void:
	if _fps_label:
		_fps_label.text = "Godot %s\nFPS: %d" % [Engine.get_version_info()["string"], Engine.get_frames_per_second()]
	_fps_timer += delta
	if _fps_timer >= 1.0:
		_fps_timer = 0.0
		print("Current FPS: ", Engine.get_frames_per_second())


func _ready() -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	_fps_label = Label.new()
	_fps_label.name = "FPSLabel"
	_fps_label.anchor_left = 0.5
	_fps_label.anchor_right = 0.5
	_fps_label.anchor_top = 1.0
	_fps_label.anchor_bottom = 1.0
	_fps_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_fps_label.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_fps_label.offset_bottom = -85.0
	_fps_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_fps_label.add_theme_font_size_override("font_size", 22)
	_fps_label.add_theme_color_override("font_color", Color.WHITE)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.7)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	_fps_label.add_theme_stylebox_override("normal", style)

	ui.add_child(_fps_label)

	status_label.add_theme_font_size_override("font_size", 32)
	status_label.resized.connect(func(): status_label.pivot_offset = status_label.size / 2)
	score_label.resized.connect(func(): score_label.pivot_offset = score_label.size / 2)
	reset_button.resized.connect(func(): reset_button.pivot_offset = reset_button.size / 2)

	_state = BoardState.new()

	_animator = BoardAnimator.new()
	_animator.init(ui, grid_container, status_label, score_label, reset_button)

	for i in range(9):
		var button := _animator.get_button(i) as Button
		button.pressed.connect(_on_button_pressed.bind(i))
		button.custom_minimum_size = Vector2(100, 100)
		button.add_theme_font_size_override("font_size", 48)
		button.pivot_offset = Vector2(50, 50)

	reset_button.pressed.connect(_on_reset_pressed)
	reset_button.pivot_offset = reset_button.size / 2

	await get_tree().process_frame
	_update_turn_visuals()


func _on_button_pressed(index: int) -> void:
	var result := _state.place_piece(index) as Dictionary

	match result["type"]:
		BoardState.PlaceResultType.INVALID:
			return

		BoardState.PlaceResultType.WIN:
			var button := _animator.get_button(index) as Button
			_animator.animate_place(button, result["winner"])
			if result.has("removed_index"):
				_animator.clear_button_instant(_animator.get_button(result["removed_index"]))
			_animator.animate_win(result["combo"], result["winner"])
			_animator.update_score(_state.score_x, _state.score_o)

		BoardState.PlaceResultType.PLACED:
			var placed_player := "X" if result["next_player"] == "O" else "O"
			var button := _animator.get_button(index) as Button
			_animator.animate_place(button, placed_player)
			if result.has("removed_index"):
				_animator.animate_remove(_animator.get_button(result["removed_index"]))
			_update_turn_visuals()


func _on_reset_pressed() -> void:
	_animator.animate_reset()
	_state.reset()
	await get_tree().create_timer(0.25).timeout
	_update_turn_visuals()


func _update_turn_visuals() -> void:
	var oldest := _state.get_oldest_move_index() as int
	_animator.animate_turn_change(_state.current_player, oldest)
