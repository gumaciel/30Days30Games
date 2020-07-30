extends Area2D


var speed = 500

func _physics_process(delta):
	translate(Vector2(0, -1) * speed * delta)
	if position.y <= -50:
		queue_free()

func _on_Bullet_body_entered(body):
	body.queue_free()
