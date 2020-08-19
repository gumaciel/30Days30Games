extends Node2D

var pre_root = preload("res://src/core/Root.tscn")
var pre_branch = preload("res://src/core/Branch.tscn")
var pre_trunk = preload("res://src/core/Trunk.tscn")

var can_instance_branch = true

func _ready():
	randomize()
	var root = pre_root.instance()
	root.position = $PositionRootReference.global_position
	root.position.y += - root.get_node("Sprite").texture.get_height() /2
	$Tree.add_child(root)
	
	for i in range(0, 7):
		var new_tree_part
		if can_instance_branch:
			var part = randi() % 2
			if part == 0:
				new_tree_part = pre_branch.instance()
				can_instance_branch = false
			else:
				new_tree_part = pre_trunk.instance()
		else:
			new_tree_part = pre_trunk.instance()
			can_instance_branch = true
		
		var direction = randi() % 2
		if direction == 0:
			new_tree_part.rotation_degrees = -180
		new_tree_part.position = $Tree.get_child($Tree.get_child_count() -1).position 
		if i != 0:
			new_tree_part.position.y -= $Tree.get_child($Tree.get_child_count() -1).get_node("Sprite").texture.get_height()
		else:
			new_tree_part.position.y -= $Tree.get_child($Tree.get_child_count() -1).get_node("Sprite").texture.get_height() / 2
		$Tree.add_child(new_tree_part)

func remove_last_tree_node():
	$Tree.get_child(0).free()
	for tree in $Tree.get_children():
		tree.position.y += tree.get_node("Sprite").texture.get_height()
	var new_tree_part
	if can_instance_branch:
		var part = randi() % 2
		if part == 0:
			new_tree_part = pre_branch.instance()
			can_instance_branch = false
		else:
			new_tree_part = pre_trunk.instance()
	else:
		new_tree_part = pre_trunk.instance()
		can_instance_branch = true
	
	var direction = randi() % 2
	if direction == 0:
		new_tree_part.rotation_degrees = -180
	new_tree_part.position = $Tree.get_child($Tree.get_child_count() -1).position 
	new_tree_part.position.y -= $Tree.get_child($Tree.get_child_count() -1).get_node("Sprite").texture.get_height()
	$Tree.add_child(new_tree_part)
	
func _on_Player_position_changed():	
	$Timer.start()


func _on_Timer_timeout():
	remove_last_tree_node()
	
