extends Node

class_name Main

func _ready():
	pass # Replace with function body.


func _input(event : InputEvent):
	if (event.is_action("enter")):
		$TranslateScene.play("change_scene")


func _on_TranslateScene_animation_finished(anim_name : String):
	if anim_name == "change_scene":
		get_tree().change_scene("res://src/tutorial/Tutorial.tscn")
		pass
