extends Node

class_name Map

export(Dictionary) var gates = {"top" : false, "bottom" : false, "left": false, "right" : false}

var probally_map = ""

func _on_TranslateScene_animation_finished(anim_name):
	if anim_name == "change_scene":
		get_tree().change_scene(probally_map)



func _on_BossGate_body_entered(body):
	if Game.key:
		var player = get_tree().root.find_node("Player", true, false)
		player.position = Vector2(300, 500)
		get_tree().change_scene("res://src/map/MapBoss.tscn")
	else:
		get_tree().root.get_node("UI/KeyAdvice").visible = true

func _on_BossGate_body_exited(body):
	if not Game.key:
		get_tree().root.get_node("UI/KeyAdvice").visible = false


func _on_Boss_boss_defetead():
	$Walls/DOORCollision.queue_free()
	$TextureMap/X.hide()
