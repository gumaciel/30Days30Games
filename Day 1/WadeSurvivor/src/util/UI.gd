extends Control


var alive = true setget set_alive

signal alive_changed

func _ready():
	pass


func set_alive(value : bool):
	alive = value
	emit_signal("alive_changed")


func _on_UI_alive_changed():
	if alive:
		$Dead.visible = false
		$Controls.visible = true
	else:
		$Dead.visible = true
		$Controls.visible = false

func _input(event : InputEvent):
	if event.is_action_pressed("restart") and not UI.alive:
		get_tree().change_scene("res://src/map/Map1.tscn")
		UI.alive = !UI.alive
