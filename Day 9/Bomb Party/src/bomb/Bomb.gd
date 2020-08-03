extends Area2D


var tile_size = 16
var size_explostion = 5
var actual_size_explostion = 0
var pre_fire_sprite = preload("res://src/bomb/FireSprite.tscn")

func _ready():
	$AnimatedSprite.play("default")
	$CollisionX.disabled = true
	$CollisionY.disabled = true
	set_process(false)

func _on_AnimatedSprite_animation_finished():
	$Timer.start()
	$CollisionX.disabled = false
	$CollisionY.disabled = false
	$AnimatedSprite.queue_free()


func _on_Timer_timeout():
	for i in range(2):
		var fire_sprite_x = pre_fire_sprite.instance()
		if i == 0:
			fire_sprite_x.position += Vector2(tile_size * actual_size_explostion, 0)
		elif i == 1:
			fire_sprite_x.position += Vector2(-tile_size * actual_size_explostion, 0)
		add_child(fire_sprite_x)
	for i in range(2):
		var fire_sprite_y = pre_fire_sprite.instance()
		if i == 0:
			fire_sprite_y.position += Vector2(0, tile_size * actual_size_explostion)
		elif i == 1:
			fire_sprite_y.position += Vector2(0, -tile_size * actual_size_explostion)
		add_child(fire_sprite_y)
	actual_size_explostion += 1


	($CollisionX.shape as RectangleShape2D).extents += Vector2(1, 0) * tile_size
	($CollisionY.shape as RectangleShape2D).extents += Vector2(0, 1) * tile_size 
	if actual_size_explostion >= size_explostion: queue_free()

func _on_Bomb_body_entered(body : Node2D):
	if body.name == "Player":
		get_tree().reload_current_scene()
	else:
		body.queue_free()
