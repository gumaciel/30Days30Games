extends Area2D

func _ready():
	if Game.key:
		queue_free()
	pass


func _on_Key_body_entered(body : Player):
	$CollisionShape2D.disabled = true
	Game.key = true
	$AudioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	queue_free()
