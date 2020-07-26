extends Area2D

func _ready():
	pass


func _on_Key_body_entered(body : Player):
	Game.key = true
	$AudioStreamPlayer.play()
	$CollisionShape2D.disabled = true

func _on_AudioStreamPlayer_finished():
	queue_free()
