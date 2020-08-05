extends Spatial

class_name Game

onready var monster = $Navigation/Enemy
onready var player = $Navigation/Player
onready var navigation = $Navigation

func _ready():
	monster.set_nav(navigation)
	monster.set_target(player)
