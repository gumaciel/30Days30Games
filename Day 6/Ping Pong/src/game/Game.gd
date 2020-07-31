extends Control


func _ready():
	UI.get_node("HBoxContainer").visible = true

func _process(delta):
	if $Ball.position.x < 320:
		UI.score -= 1
		get_tree().reload_current_scene()
	elif $Ball.position.x > 1600:
		UI.score += 1
		get_tree().reload_current_scene()
	elif $Ball.position.y < 0 or $Ball.position.y > 1200:
		get_tree().reload_current_scene()
	
