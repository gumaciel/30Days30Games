extends Area

var direction : Vector3
const SPEED = 20

export (NodePath) var joystickPath
onready var joystick : Joystick = get_node(joystickPath)

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if joystick and joystick.is_working:
		direction.x = joystick.output.x
	else: direction.x = 0

	if direction.x < 0 and transform.origin.x <= -15:
		return
	elif direction.x > 0 and transform.origin.x >= 15:
		return
	else:
		translate(direction * SPEED * delta)
		
