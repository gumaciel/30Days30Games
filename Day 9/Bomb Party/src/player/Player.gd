extends KinematicBody2D


var direction : Vector2
var speed = 100

var pre_bomb = preload("res://src/bomb/Bomb.tscn")

func _physics_process(delta):
	pass
func _unhandled_input(event : InputEvent):
	direction.x = int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left"))
	direction.y = int(event.is_action_pressed("ui_down")) - int(event.is_action_pressed("ui_up"))
	
	if direction != Vector2.ZERO:
		if direction.x > 0:
			$AnimatedSprite.flip_h = false
		elif direction.x < 0:
			$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("moving")
	else:
		$AnimatedSprite.play("idle")
		
	move_and_collide(direction * 16)


func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		var bomb = pre_bomb.instance()
		bomb.position = position
		(get_parent() as Game).get_node("Bombs").add_child(bomb)
