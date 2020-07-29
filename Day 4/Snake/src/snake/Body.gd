extends Area2D


func _ready():
	pass
func _process(delta):
	pass

func _on_Body_area_entered(area):
	get_tree().reload_current_scene()

