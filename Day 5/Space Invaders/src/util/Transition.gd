extends ColorRect


var next_scene : String

func change_to_scene(scene : String):
	next_scene = scene
	$AnimationPlayer.play("change_scene")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "change_scene":
		get_tree().change_scene(next_scene)
