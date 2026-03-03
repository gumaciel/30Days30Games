extends Node

signal cookies_changed(new_amount: float)
signal cps_changed(new_cps: float)
signal game_won(time_taken: float)
signal click_power_changed(new_power: float)
signal milestone_reached(milestone_name: String, milestone_value: float)

var cookies: float = 0.0:
	set(value):
		var old := cookies
		cookies = value
		cookies_changed.emit(cookies)
		_check_milestones(old, cookies)

var cookies_per_second: float = 0.0:
	set(value):
		cookies_per_second = value
		cps_changed.emit(cookies_per_second)

var click_power: float = 1.0:
	set(value):
		click_power = value
		click_power_changed.emit(click_power)

var total_cookies_earned: float = 0.0
var total_clicks: int = 0
var time_played: float = 0.0
var is_game_won: bool = false
var win_cost: float = 10_000_000.0

var _next_milestone_index: int = 0
var _milestones := [100, 1_000, 10_000, 100_000, 1_000_000, 10_000_000]
var _milestone_names := ["Beginner Baker", "Cookie Apprentice", "Cookie Artisan", "Cookie Master", "Cookie Tycoon", "Cookie Emperor"]

func _process(delta: float) -> void:
	if is_game_won:
		return

	time_played += delta
	if cookies_per_second > 0:
		var earned := cookies_per_second * delta
		cookies += earned
		total_cookies_earned += earned

func click() -> void:
	if not is_game_won:
		cookies += click_power
		total_cookies_earned += click_power
		total_clicks += 1

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
	click_power = 1.0
	total_cookies_earned = 0.0
	total_clicks = 0
	time_played = 0.0
	is_game_won = false
	_next_milestone_index = 0

func _check_milestones(old_val: float, new_val: float) -> void:
	while _next_milestone_index < _milestones.size():
		var threshold: float = _milestones[_next_milestone_index]
		if old_val < threshold and new_val >= threshold:
			milestone_reached.emit(_milestone_names[_next_milestone_index], threshold)
			_next_milestone_index += 1
		else:
			break

func format_number(n: float) -> String:
	if n >= 1_000_000_000:
		return str(snapped(n / 1_000_000_000.0, 0.1)) + "B"
	elif n >= 1_000_000:
		return str(snapped(n / 1_000_000.0, 0.1)) + "M"
	elif n >= 10_000:
		return str(snapped(n / 1_000.0, 0.1)) + "K"
	return str(snapped(n, 0.1))
