extends KinematicBody2D


class_name Player

export var speed : float = 300

export (NodePath) var joystickPath
onready var joystick := get_node(joystickPath)
var pre_bullet := preload("res://src/player/Bullet.tscn")
var can_shoot := false
var max_particles_velocity := 50
var particles_velocity := 0.1

var life := 5

var time_to_shoot := 0.5
var calculate_time := 0.0

var time_shake = 0

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	if joystick and joystick.is_working:
		calculate_time += delta
		if calculate_time >= time_to_shoot:
			var bullet = pre_bullet.instance()
			bullet.position = position
			get_parent().add_child(bullet)
			calculate_time = 0.0
		move_and_slide(joystick.output * speed)
		if joystick.output.y < 0:
			$MovingParticles.emitting = true
			particles_velocity = clamp(particles_velocity, 0.1, max_particles_velocity) + (speed * delta)
			$MovingParticles.process_material.set("initial_velocity", particles_velocity)
		else:
			stop_moving_particles()
	elif joystick != null:
		stop_moving_particles()

func stop_moving_particles():
	$MovingParticles.emitting = false
	particles_velocity = 0.1
	
func _process(delta):
	if time_shake > 0:
		$Camera2D.offset = Vector2(cos(rad2deg(time_shake)), sin(rad2deg(time_shake))) * 2
		time_shake -= delta
	else:
		$Camera2D.offset = Vector2.ZERO
		set_process(false)

func _on_Area2D_area_entered(area):
	life -= 1
	get_parent().get_node("UI/Lifes").life = life
	time_shake = 0.5
	set_process(true)
	if life <= 0:
		queue_free()
		get_parent().get_node("Transition").change_to_scene("res://src/main/Main.tscn")

