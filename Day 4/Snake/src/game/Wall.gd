extends Area2D


func _ready():
	pass # Replace with function body.



func _on_Wall_area_entered(area):
	get_tree().reload_current_scene()
