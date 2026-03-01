extends RefCounted

enum PlaceResultType {PLACED, WIN, INVALID}

const WIN_COMBOS: Array[Array] = [
	[0, 1, 2], [3, 4, 5], [6, 7, 8],
	[0, 3, 6], [1, 4, 7], [2, 5, 8],
	[0, 4, 8], [2, 4, 6],
]

var board: Array[String] = ["", "", "", "", "", "", "", "", ""]
var current_player: String = "X"
var game_over: bool = false
var moves_x: Array[int] = []
var moves_o: Array[int] = []
var score_x: int = 0
var score_o: int = 0


func is_valid_move(index: int) -> bool:
	return not game_over and board[index] == ""


func place_piece(index: int) -> Dictionary:
	if not is_valid_move(index):
		return {"type": PlaceResultType.INVALID}

	var p_moves := _current_moves()

	board[index] = current_player
	p_moves.append(index)

	var removed_index: int = -1
	if p_moves.size() == 4:
		removed_index = p_moves.pop_front()
		board[removed_index] = ""

	var win_combo := check_win()
	if win_combo.size() > 0:
		game_over = true
		_record_win(current_player)
		var win_result := {
			"type": PlaceResultType.WIN,
			"winner": current_player,
			"combo": win_combo,
		}
		if removed_index >= 0:
			win_result["removed_index"] = removed_index
		return win_result

	_switch_player()

	var result := {
		"type": PlaceResultType.PLACED,
		"next_player": current_player,
	}
	if removed_index >= 0:
		result["removed_index"] = removed_index
	return result


func get_oldest_move_index() -> int:
	var p_moves := _current_moves()
	if p_moves.size() >= 2:
		return p_moves[0]
	return -1


func reset() -> void:
	board = ["", "", "", "", "", "", "", "", ""]
	current_player = "X"
	game_over = false
	moves_x.clear()
	moves_o.clear()


func check_win() -> Array:
	for combo: Array in WIN_COMBOS:
		var a: int = combo[0]
		var b: int = combo[1]
		var c: int = combo[2]
		if board[a] != "" and board[a] == board[b] and board[a] == board[c]:
			return combo
	return []


func _current_moves() -> Array[int]:
	return moves_x if current_player == "X" else moves_o


func _record_win(player: String) -> void:
	if player == "X":
		score_x += 1
	else:
		score_o += 1


func _switch_player() -> void:
	current_player = "O" if current_player == "X" else "X"
