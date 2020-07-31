extends Control


func _ready():
	UI.get_node("HBoxContainer").visible = false

func _on_Button_pressed():
	$Start.disabled = true
	$Transition.change_scene("res://src/game/Game.tscn")
