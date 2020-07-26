extends Area2D

export(int) var speed = 500

var direction := "right"

func _ready():
	pass
	
func _process(delta):
	if direction == "right":
		position.x += speed * delta
		rotation_degrees = 0
	elif direction == "left":
		position.x -= speed * delta
		rotation_degrees = 180
	elif direction == "up":
		position.y -= speed * delta
		rotation_degrees = 270
	elif direction == "down":
		position.y += speed * delta
		rotation_degrees = 90
		
func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_Bullet_body_entered(body : Enemy):
	body.life -= 2
	body.get_node("DamagePlayer").play("damage")

	queue_free()
