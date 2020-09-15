extends Area2D

var move : Vector2
var speed = 200
var pre_bullet = preload("res://src/actors/Bullet.tscn")

func _process(delta):
	move.x = int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))
	move.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	look_at(get_global_mouse_position())
	rotate(rad2deg(-90))
	if move != Vector2.ZERO:
		move = move.rotated(rotation)
		translate(move * delta * speed)
	
	if Input.is_action_just_pressed("ui_accept"):
		var bullet : Bullet = pre_bullet.instance()
		bullet.position = position
		bullet.move = -Vector2(1, 1).rotated(rotation)
		$Bullets.add_child(bullet)
