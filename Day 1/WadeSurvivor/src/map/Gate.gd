extends Area2D

class_name Gate

export(String, "TOP", "BOTTOM", "LEFT", "RIGHT") var id = "TOP"

var limit_map = 5

func _ready():
	randomize()


func _on_Gate_body_entered(body : KinematicBody2D):
	_find_gate()

func _find_gate():
	var random_map : String
	var map : Map
	var gate_founded : String

	var new_position_player : Vector2
	
	if self.id == "BOTTOM":
		random_map = str(Game.gate_dict.top[((randi() % Game.gate_dict.top.size()))])
		gate_founded = "Top"
	elif self.id == "TOP":
		random_map = str(Game.gate_dict.bottom[((randi() % Game.gate_dict.bottom.size()))])
		gate_founded = "Bottom"
	elif self.id == "LEFT":
		random_map = str(Game.gate_dict.right[((randi() % Game.gate_dict.right.size()))])
		gate_founded = "Right"
	elif self.id == "RIGHT":
		random_map = str(Game.gate_dict.left[((randi() % Game.gate_dict.left.size()))])
		gate_founded = "Left"


	map = (Game.pre_maps[random_map].instance() as Map)
	var gate = map.get_node("Gates").find_node(gate_founded)
	new_position_player = gate.global_position + gate.get_node("Position2D").global_position
	
	
	get_parent().get_parent().queue_free()
	map.get_node("Player").position = new_position_player
	get_tree().root.add_child(map)
	print(random_map)
