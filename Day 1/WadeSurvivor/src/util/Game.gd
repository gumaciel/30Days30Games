extends Node

var key = false

var alive = true

var pre_maps = {
	"1": preload("res://src/map/Map1.tscn"), 
	"2": preload("res://src/map/Map2.tscn"),
	"3": preload("res://src/map/Map3.tscn"),
	"4": preload("res://src/map/Map4.tscn"),
	"5": preload("res://src/map/Map5.tscn"),
	"Boss": preload("res://src/map/MapBoss.tscn")
}

var gate_dict = {"bottom": [], "left": [], "right": [], "top": []}

func _ready():
	for map in pre_maps:
		var gates = pre_maps[map].get_state().get_node_property_value(0, 0)
		if map == "Boss": continue
		if (gates as Dictionary).get("bottom"):
			gate_dict["bottom"].append(map)
		if (gates as Dictionary).get("left"):
			gate_dict["left"].append(map)
		if (gates as Dictionary).get("right"):
			gate_dict["right"].append(map)
		if (gates as Dictionary).get("top"):
			gate_dict["top"].append(map)
		
	print(gate_dict)
