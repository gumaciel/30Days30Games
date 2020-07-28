extends Control

var alive = true setget set_alive

signal alive_changed
var pre_map1 = preload("res://src/map/Map1.tscn")

func _ready():
	pass



func set_alive(value : bool):
	alive = value
	emit_signal("alive_changed")


func _on_UI_alive_changed():
	if alive:
		$Restart.visible = false
		$Controls.visible = true
	else:
		$Restart.visible = true
		$Controls.visible = false

func _input(event : InputEvent):
	if event.is_action_pressed("restart") and not alive:
		var map1 = pre_map1.instance()
		get_parent().get_child(1).queue_free()
		get_parent().add_child(map1)
		alive = !alive
		emit_signal("alive_changed")
