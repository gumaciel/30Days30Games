extends Spatial

var pre_enemy = preload("res://src/core/Enemy.tscn")

var time = 0

func _ready():
	randomize()

func _process(delta):
	time += delta

func _on_SpawnEnemyTimer_timeout():
	var enemy = pre_enemy.instance()
	enemy.transform.origin = $SpawnEnemyPositions.get_child(randi() % $SpawnEnemyPositions.get_child_count()).transform.origin
	add_child(enemy)


func _on_DestroyEnemy_area_entered(area : Spatial):
	area.queue_free()


func _on_Button_pressed():
	get_tree().reload_current_scene()

func game_over():
	set_process(false)
	$Control.visible = true
	$Control/Label.text = "TIME: " + str(int(time))
