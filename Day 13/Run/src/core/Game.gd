extends Node2D

var pre_enemy = preload("res://src/actors/Enemy.tscn")

func _process(delta):
	$ParallaxBackground/ParallaxLayer.motion_offset.x -= 100 * delta
	pass


func _on_Timer_timeout():
	var enemy = pre_enemy.instance()
	enemy.position = $SpawnEnemyPosition.position
	add_child(enemy)
