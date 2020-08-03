extends Control


export(NodePath) onready var enemy = $Enemy
export(NodePath) onready var player = $Pacman

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_path_to_player():
	var path = []
	if enemy != null and player != null:
		path = $ColorRect/Navigation2D.get_simple_path(enemy.position, player.position, false)
	return path
