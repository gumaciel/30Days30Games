extends KinematicBody

const speed : int = 10
var foward_direction := Vector3.FORWARD * speed
var left_direction := Vector3.LEFT * speed
var actual_direction : Vector3
onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity : Vector3

var points : int = 0 setget set_points
signal points_changed(value)
signal died 

func _ready():
	set_process_input(false)

func set_points(value : int):
	points = value
	emit_signal("points_changed", points)

func _physics_process(delta):
	if not is_on_floor():
		velocity.x = actual_direction.x
		velocity.y += delta * gravity
		velocity.z = actual_direction.z
	velocity = move_and_slide(velocity)
	if transform.origin.y < -2:
		emit_signal("died")

func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if actual_direction == foward_direction:
				actual_direction = left_direction
			elif actual_direction == left_direction:
				actual_direction = foward_direction
			self.points = points + 1
			move_and_slide(actual_direction)



