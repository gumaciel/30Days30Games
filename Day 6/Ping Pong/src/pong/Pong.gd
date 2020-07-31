extends KinematicBody2D

class_name Pong

export var velocity = 500


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position = Vector2(position.x, get_global_mouse_position().y)
