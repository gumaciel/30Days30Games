extends KinematicBody2D

class_name Number

signal number_value_changed(value)

var new_position : Vector2 setget set_new_position
var number_value = "2" setget set_number_value
var velocity := 100000
var collider : KinematicBody2D


func _ready():
	var texture = load("res://assets/pieces/" + number_value + ".svg")
	$Sprite.texture = texture
	$RayCast2D.enabled = true
	set_physics_process(false)

func _physics_process(delta):
	move_and_slide((new_position) * velocity)
	if is_on_wall():
		set_physics_process(false)

func _process(delta):
	check_colliding()


func check_colliding():
	if $RayCast2D.is_colliding():
		var number = ($RayCast2D.get_collider() as Number)
		if number.number_value == number_value:
			collider = number
			self.number_value = str(int(number_value) * 2)
			

func set_new_position(value : Vector2):
	new_position = value
	$RayCast2D.position = Vector2(100, 100) * new_position
	$RayCast2D.cast_to = new_position * 50
	print($RayCast2D.position)
	set_physics_process(true)

func set_number_value(value : String):
	number_value = str(value)
	emit_signal("number_value_changed", number_value, collider)
