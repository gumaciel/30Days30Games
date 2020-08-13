extends Node2D

var pre_ball = preload("res://src/actors/Ball.tscn")

func _ready():
	factory_ball()

func _process(delta):
	$Circle.rotate(1 * delta)

func _on_Area2D_area_entered(area : Area2D):
	var ball = area.get_parent()
	ball.set_process(false)
	remove_child(ball)
	ball.global_position = Vector2(625, 1400)
	area.collision_mask = 2
	$Circle.add_child(ball)
	factory_ball()

		
func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			var ball = find_node("Ball", false, false)
			ball.set_process(true)


func factory_ball():
	var ball = pre_ball.instance()
	ball.position = $BallSpawnPosition2D.position
	add_child(ball)
