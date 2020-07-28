extends KinematicBody2D

class_name Enemy

export(int) var speed := 100
onready var player = get_parent().get_node("Player")
var move : Vector2
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 

func _ready():

	pass

func _physics_process(delta):
	if player != null:
		move = position.direction_to(player.position)
		$AnimatedSprite.play("walking")
		if not is_on_floor():
			move.y += gravity * delta
		else:
			move.y = 0
	else:
		move = Vector2()
		
	move = move.normalized()

	if move.x < -0.5:
		$AnimatedSprite.flip_h = true
	elif move.x > 0.5:
		$AnimatedSprite.flip_h = false

	move = move_and_slide(move * speed, Vector2.UP)


func _on_DamageArea_body_entered(body : Node):
	$AnimatedSprite.play("idle")
	print($AnimatedSprite.animation)
	get_parent().get_parent().get_node("UI").alive = false
	body.queue_free()
	set_physics_process(false)


func _on_Explosion_animation_finished():
	queue_free()

func disable():
	$DamageArea.queue_free()
	$CollisionShape2D.queue_free()
	$Explosion.visible = true
	$Explosion.play("explosion")
	set_physics_process(false)
