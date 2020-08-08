extends Node2D

var game_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Cat.position = $Positions.get_child(randi() % $Positions.get_child_count()).position


func _process(delta):
	game_time += delta
	$TimeLabel.text = "Time: " + str(game_time)


func _on_Cat_won():
	$Cat.queue_free()
	set_process(false)
	$TimeLabel.modulate = Color.green
	$Timer.start()

func _on_Timer_timeout():
	get_tree().reload_current_scene()
	pass # Replace with function body.
