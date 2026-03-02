extends RefCounted
class_name Upgrade

var upgrade_name: String
var base_cost: float
var cost: float
var cps: float
var count: int
var multiplier: float

func _init(p_name: String, p_base_cost: float, p_cps: float, p_multiplier: float = 1.15) -> void:
	self.upgrade_name = p_name
	self.base_cost = p_base_cost
	self.cost = p_base_cost
	self.cps = p_cps
	self.multiplier = p_multiplier
	self.count = 0

func get_current_cost() -> float:
	return self.cost

func purchase() -> void:
	self.count += 1
	self.cost = self.base_cost * pow(self.multiplier, self.count)

func reset() -> void:
	self.count = 0
	self.cost = self.base_cost

func get_display_text() -> String:
	return self.upgrade_name + " (" + str(self.count) + ")\nCost: " + str(floor(self.cost)) + " | CPS: +" + str(self.cps)
