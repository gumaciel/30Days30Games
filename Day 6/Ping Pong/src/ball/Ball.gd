extends RigidBody2D


var max_speed = 1100

func _physics_process(delta):
	var new_speed = get_linear_velocity().normalized()
	new_speed *= max_speed
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
		set_linear_velocity(new_speed)
	elif abs(get_linear_velocity().x) < -max_speed or abs(get_linear_velocity().y) < -max_speed:
		set_linear_velocity(-new_speed)
	

