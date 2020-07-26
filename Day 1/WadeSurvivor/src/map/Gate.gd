extends Area2D

class_name Gate

export(String, "TOP", "BOTTOM", "LEFT", "RIGHT") var id = "TOP"

var limit_map = 5

func _ready():
	randomize()


func _on_Gate_body_entered(body : KinematicBody2D):
	_find_gate(randi() % limit_map + 1)

func _find_gate(value : int):
	var probally_map = "res://src/map/Map" + str(value) + ".tscn"
	var map = load(probally_map)
	var instanced_map = map.instance()
	var player = get_tree().root.find_node("Player", true, false)
	
	var found = false
	
	for gate in instanced_map.get_node("Gates").get_children():
		if self.id == "BOTTOM" and gate.id == "TOP":
			found = !found
			player.position = gate.global_position + gate.get_node("Position2D").global_position
			get_tree().change_scene(probally_map)
		elif self.id == "TOP" and gate.id == "BOTTOM":
			found = !found
			player.position = gate.global_position + gate.get_node("Position2D").global_position
			get_tree().change_scene(probally_map)
		elif self.id == "LEFT" and gate.id == "RIGHT":
			found = !found
			player.position = gate.global_position + gate.get_node("Position2D").global_position
			get_tree().change_scene(probally_map)
		elif self.id == "RIGHT" and gate.id == "LEFT":
			found = !found
			player.position = gate.global_position + gate.get_node("Position2D").global_position
			get_tree().change_scene(probally_map)

	if found:
		#get_tree().root.find_node("Map", true, false).get_node("TranslateScene").play("change_scene")
		pass
	else:
		_find_gate(randi() % limit_map + 1)
