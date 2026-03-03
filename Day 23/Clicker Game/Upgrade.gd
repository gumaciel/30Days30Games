extends RefCounted
class_name Upgrade

var upgrade_name: String
var description: String
var emoji: String
var base_cost: float
var cost: float
var cps: float
var count: int
var multiplier: float

func _init(p_name: String, p_emoji: String, p_desc: String, p_base_cost: float, p_cps: float, p_multiplier: float = 1.15) -> void:
	upgrade_name = p_name
	emoji = p_emoji
	description = p_desc
	base_cost = p_base_cost
	cost = p_base_cost
	cps = p_cps
	multiplier = p_multiplier
	count = 0

func get_current_cost() -> float:
	return cost

func purchase() -> void:
	count += 1
	cost = base_cost * pow(multiplier, count)

func reset() -> void:
	count = 0
	cost = base_cost

func get_display_text() -> String:
	return emoji + " " + upgrade_name + " (" + str(count) + ")\n" + _format_number(floor(cost)) + " | +" + str(cps) + "/s"

static func _format_number(n: float) -> String:
	if n >= 1_000_000_000:
		return str(snapped(n / 1_000_000_000.0, 0.1)) + "B"
	elif n >= 1_000_000:
		return str(snapped(n / 1_000_000.0, 0.1)) + "M"
	elif n >= 1_000:
		return str(snapped(n / 1_000.0, 0.1)) + "K"
	return str(int(n))
