extends Node

func _ready():
	pass


func _input(event : InputEvent):
	if event.is_action_released("enter"):
		$TranslateScene.play("change_scene")



func _on_TranslateScene_animation_finished(anim_name : String):
	if anim_name == "change_scene":
		get_tree().change_scene("res://src/map/Map1.tscn")
		var player = load("res://src/Player/Player.tscn").instance()
		player.position = Vector2(300, 500)
		get_tree().root.add_child(player)
