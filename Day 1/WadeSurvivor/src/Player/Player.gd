extends KinematicBody2D

class_name Player

var pre_bullet = preload("res://src/Bullet/Bullet.tscn")

var velocity := Vector2()
var speed := 500
var last_anim := "idle"
var shoot := {"down": false, "up": false, "right" :false, "left": false}
var can_shoot := true

var life = 100 setget set_life

func _ready():
	$TextureProgress.max_value = life
	$TextureProgress.value = life


func _physics_process(delta : float):
	velocity.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	shoot.down = Input.is_action_pressed("shoot_down")
	shoot.up = Input.is_action_pressed("shoot_up")
	shoot.right = Input.is_action_pressed("shoot_right")
	shoot.left = Input.is_action_pressed("shoot_left")
	
	_animation()
	_shoot()
	move_and_slide(velocity * speed)

func set_life(value):
	life -= value
	$TextureProgress.value = life

func apply_damage(value: int):
	set_life(value)
	$DamagePlayer.play("damage")
	if life <= 0: #gameover
		queue_free()
		get_tree().root.get_node("/root/UI/Dead").visible = true

func _shoot():
	if shoot.down or shoot.up or shoot.right or shoot.left:
		if can_shoot:
			var bullet = pre_bullet.instance()
			get_parent().add_child(bullet)
			if shoot.down:
				bullet.position = $BulletPositions/Down.global_position
				bullet.direction = "down"
			elif shoot.up:
				bullet.position = $BulletPositions/Up.global_position
				bullet.direction = "up"
			elif shoot.right:
				bullet.position = $BulletPositions/Right.global_position
				bullet.direction = "right"
			elif shoot.left:
				bullet.position = $BulletPositions/Left.global_position
				bullet.direction = "left"
			can_shoot = false
			$TimerShoot.start()

func _animation():
	if velocity == Vector2(0, 0):
		if shoot.right or shoot.left:
			$AnimatedSprite.play("shooting_idle_left_right")
			if shoot.right:
				$AnimatedSprite.flip_h = true
				last_anim = "right"
			elif shoot.left:
				$AnimatedSprite.flip_h = false
				last_anim = "left"
		elif shoot.down:
			$AnimatedSprite.play("shooting_idle_down")
			last_anim = "down"
		elif shoot.up:
			$AnimatedSprite.play("idle_up")
			last_anim = "up"
		else:
			if last_anim == "up":
				$AnimatedSprite.play("idle_up")
			elif last_anim == "down":
				$AnimatedSprite.play("idle_down")
			elif last_anim == "left" or last_anim == "right":
				$AnimatedSprite.play("idle_left_right")
	else:
		if shoot.right or shoot.left: #if is shooting, then run the animation of shoot and running
			$AnimatedSprite.play("shooting_running_left_right")
			last_anim = "left_right"
			if shoot.right:
				$AnimatedSprite.flip_h = true
			elif shoot.left:
				$AnimatedSprite.flip_h = false
		elif shoot.down:
			$AnimatedSprite.play("shooting_running_down")
			last_anim = "down"
		elif shoot.up:
			$AnimatedSprite.play("running_up")
			last_anim = "up"
		else: #if is not shooting, then run only the animation of running
			if velocity.y > 0:
				$AnimatedSprite.play("running_down")
				last_anim = "down"
			elif velocity.y < 0:
				$AnimatedSprite.play("running_up")
				last_anim = "up"
			else:
				$AnimatedSprite.play("running_left_right")
				if velocity.x == 1:
					$AnimatedSprite.flip_h = true
					last_anim = "right"
				else:
					$AnimatedSprite.flip_h = false
					last_anim = "left"

func _on_TimerShoot_timeout():
	can_shoot = true
	pass # Replace with function body.
