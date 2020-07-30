extends Control

var pre_enemy = preload("res://src/enemy/Enemy.tscn")

func _on_Timer_timeout():
	var enemy = pre_enemy.instance()
	enemy.position = Vector2(randi() % 447 + 93 , -40)
	$Enemies.add_child(enemy)

