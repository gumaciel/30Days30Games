extends Node

signal upgrade_purchased(upgrade_index: int, new_cps: float)

var upgrades: Array[Upgrade] = []

func _ready() -> void:
	_initialize_upgrades()

func _initialize_upgrades() -> void:
	upgrades.clear()
	upgrades.append(Upgrade.new("Cursor", 15.0, 0.1))
	upgrades.append(Upgrade.new("Grandma", 100.0, 1.0))
	upgrades.append(Upgrade.new("Farm", 1100.0, 8.0))
	upgrades.append(Upgrade.new("Mine", 12000.0, 47.0))
	upgrades.append(Upgrade.new("Factory", 130000.0, 260.0))

func get_upgrades() -> Array[Upgrade]:
	return upgrades

func attempt_purchase(index: int, game_data: Node) -> bool:
	if index < 0 or index >= upgrades.size():
		return false

	var upg: Upgrade = upgrades[index]
	var current_cost: float = upg.get_current_cost()

	if game_data.cookies >= current_cost:
		game_data.cookies -= current_cost
		upg.purchase()
		game_data.cookies_per_second += upg.cps
		upgrade_purchased.emit(index, game_data.cookies_per_second)
		return true

	return false

func reset_all() -> void:
	for upg in upgrades:
		upg.reset()
