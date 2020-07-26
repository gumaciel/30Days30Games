extends "res://src/enemy/Enemy.gd"

signal boss_defetead

func _ready():
	pass

func set_life(value):
	life = value
	$TextureProgress.value = life
	if life <= 0:
		emit_signal("boss_defetead")
		queue_free()
