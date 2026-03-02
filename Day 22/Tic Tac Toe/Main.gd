extends Control

const BoardState := preload("res://BoardState.gd")
const BoardAnimator := preload("res://BoardAnimator.gd")

@onready var status_label: Label = $StatusLabel
@onready var score_label: Label = $ScoreLabel
@onready var grid_container: GridContainer = $GridContainer
@onready var reset_button: Button = $ResetButton

var _state: RefCounted
var _animator: RefCounted


func _ready() -> void:
	_state = BoardState.new()

	_animator = BoardAnimator.new()
	_animator.init(self , grid_container, status_label, score_label, reset_button)

	for i in range(9):
		var button: Button = _animator.get_button(i)
		button.pressed.connect(_on_button_pressed.bind(i))
		button.custom_minimum_size = Vector2(100, 100)
		button.add_theme_font_size_override("font_size", 48)
		button.pivot_offset = Vector2(50, 50)

	reset_button.pressed.connect(_on_reset_pressed)
	reset_button.pivot_offset = reset_button.size / 2
	status_label.add_theme_font_size_override("font_size", 32)
	status_label.pivot_offset = status_label.size / 2

	_update_turn_visuals()


func _on_button_pressed(index: int) -> void:
	var result: Dictionary = _state.place_piece(index) as Dictionary

	match result["type"]:
		BoardState.PlaceResultType.INVALID:
			return

		BoardState.PlaceResultType.WIN:
			var button: Button = _animator.get_button(index) as Button
			_animator.animate_place(button, result["winner"])
			if result.has("removed_index"):
				_animator.clear_button_instant(_animator.get_button(result["removed_index"]))
			_animator.animate_win(result["combo"], result["winner"])
			_animator.update_score(_state.score_x, _state.score_o)

		BoardState.PlaceResultType.PLACED:
			var placed_player: String = "X" if result["next_player"] == "O" else "O"
			var button: Button = _animator.get_button(index) as Button
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
	var oldest: int = _state.get_oldest_move_index() as int
	_animator.animate_turn_change(_state.current_player, oldest)
