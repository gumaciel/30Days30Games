extends KinematicBody2D

export(NodePath) onready var game = get_parent()
var path = []
var direction : Vector2
var speed = 25

func _ready():
	pass # Replace with function body.

func _process(delta):
	if path.size() > 1:
		var position_to_move = path[0]
		direction = (position_to_move - position).normalized()
		var distance = position.distance_to(path[0])
		if distance > 1:
			position += direction * speed * delta 
		else:
			path.remove(0)
	else:
		path = game.get_path_to_player()


func _on_Area2DPlayer_body_entered(body : Node2D):
	body.queue_free()
	get_tree().reload_current_scene()
