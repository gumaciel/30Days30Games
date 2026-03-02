extends Node

signal cookies_changed(new_amount: float)
signal cps_changed(new_cps: float)
signal game_won(time_taken: float)

var cookies: float = 0.0 :
	set(value):
		cookies = value
		cookies_changed.emit(cookies)

var cookies_per_second: float = 0.0 :
	set(value):
		cookies_per_second = value
		cps_changed.emit(cookies_per_second)

var time_played: float = 0.0
var is_game_won: bool = false
var win_cost: float = 1_000_000.0

func _process(delta: float) -> void:
	if is_game_won:
		return

	time_played += delta
	if cookies_per_second > 0:
		cookies += cookies_per_second * delta

func click() -> void:
	if not is_game_won:
		cookies += 1.0

func attempt_win() -> bool:
	if cookies >= win_cost and not is_game_won:
		cookies -= win_cost
		is_game_won = true
		game_won.emit(time_played)
		return true
	return false

func reset() -> void:
	cookies = 0.0
	cookies_per_second = 0.0
	time_played = 0.0
	is_game_won = false
