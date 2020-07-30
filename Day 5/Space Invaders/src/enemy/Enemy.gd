extends KinematicBody2D


export var velocity = 100

var move = Vector2(0, 1)

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move_and_slide(move * velocity)
	if position.y >= 1230:
		queue_free()
