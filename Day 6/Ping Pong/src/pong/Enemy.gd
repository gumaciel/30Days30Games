extends KinematicBody2D

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var motion =  (get_parent().get_node("Ball").position.y - position.y) * 0.1
	translate(Vector2(0, motion))
