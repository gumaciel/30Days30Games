extends Area2D


var pre_map_boss = preload("res://src/map/MapBoss.tscn")

func _ready():
	pass


func _on_Portal_body_entered(body):
	var map_boss = pre_map_boss.instance()
	get_parent().queue_free()
	get_parent().get_parent().add_child(map_boss)
