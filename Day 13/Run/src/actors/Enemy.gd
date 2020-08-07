extends Area2D


var speed = 250

func _physics_process(delta):
	translate(Vector2.LEFT * speed * delta)

func _on_Enemy_body_entered(body):
	get_tree().reload_current_scene()
	pass # Replace with function body.
