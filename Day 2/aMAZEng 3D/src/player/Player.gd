extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 20
var mouse_sens = 0.3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var move : Vector3

	var aim = $Camera.global_transform.basis
	if Input.is_action_pressed("ui_right"):
		move += aim.x
	if Input.is_action_pressed("ui_left"):
		move -= aim.x
	if Input.is_action_pressed("ui_up"):
		move -= aim.z
	if Input.is_action_pressed("ui_down"):
		move += aim.z

	move.normalized()
	var target = move * speed
	
	move = move.linear_interpolate(target, speed * delta)	
	move_and_slide(move) 

func _process(delta):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		var rotate = int(Input.is_action_pressed("rotate_left")) - int(Input.is_action_pressed("rotate_right")) 
		rotate_y(deg2rad(rotate * (mouse_sens * 500 * delta)))
		
func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
