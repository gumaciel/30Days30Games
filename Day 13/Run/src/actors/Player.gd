extends KinematicBody2D


const GRAVITY = 10
const ACELLERATION = 50
var speed = 0
func _ready():
	pass # Replace with function body.

func _input(event : InputEvent):
	print(is_on_floor())
	if event is InputEventMouseButton and is_on_floor():
		speed = 500
		move_and_slide(Vector2.UP * speed, Vector2.UP)
	
func _physics_process(delta):
	if not is_on_floor():
		speed -=  GRAVITY * ACELLERATION * delta
		move_and_slide(Vector2.UP * speed, Vector2.UP)
