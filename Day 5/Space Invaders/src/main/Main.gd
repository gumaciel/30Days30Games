extends Control



func _ready():
	randomize()

func _on_StartGame_pressed():
	$CenterContainer/VBoxContainer/StartGame.disabled = true
	$AnimationPlayer.get_animation("start").track_set_key_value(0, 0, $Player.position)
	$AnimationPlayer.play("start")
	$AudioStreamPlayer.play()



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		$Transition.change_to_scene("res://src/game/Game.tscn")
