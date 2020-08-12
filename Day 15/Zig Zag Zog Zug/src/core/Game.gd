extends Spatial

var pre_wall = preload("res://src/core/Wall.tscn")

func _ready():
	randomize()

func _on_Timer_timeout():
	var wall = pre_wall.instance()
	wall.transform.origin = $Walls.get_child($Walls.get_child_count()-1).transform.origin

	var random_wall_transform = randi() % 2
	if random_wall_transform == 1:
		wall.transform.origin.x -= 2
	else:
		wall.transform.origin.z -= 2
	$Walls.add_child(wall)

func _on_Ball_died():
	$Ball.queue_free()
	$Walls.queue_free()
	$Timer.queue_free()
	$UI/RestartButton.visible = true
	$UI/VBoxContainer/Score.visible = true
	$UI/VBoxContainer/Highscore.visible = true


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

func _on_Advice_pressed():
	$UI/Advice.queue_free()
	$Ball.actual_direction = $Ball.foward_direction
	$Ball.set_process_input(true)
	$Timer.start()
	$UI/VBoxContainer/Highscore.visible = false
	$UI/VBoxContainer/Score.visible = true
