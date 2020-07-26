extends KinematicBody2D

class_name Enemy

export var life = 10 setget set_life

var player : KinematicBody2D = null
var move = Vector2()
export var speed = 100

var current_animation = "left_right"

func _ready():
	$TextureProgress.max_value = life
	$TextureProgress.value = life
	player = get_parent().find_node("Player")
	$AnimatedSprite.play("left_right")

func set_life(value):
	life = value
	$TextureProgress.value = life
	if life <= 0:
		queue_free()
	
func _physics_process(delta):
	if player != null:
		move = position.direction_to(player.position)
	else:
		move = Vector2()
	
	move = move.normalized()

	if move.x < -0.5:
		$AnimatedSprite.flip_h = false
	elif move.x > 0.5:
		$AnimatedSprite.flip_h = true

	move = move_and_slide(move * speed)

func _on_AreaDamage_body_entered(body):
	$AreaDamage.set_deferred("monitoring", false)
	$Timer.start()
	body.apply_damage(10)

func _on_Timer_timeout():
	$AreaDamage.set_deferred("monitoring", true)


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.
