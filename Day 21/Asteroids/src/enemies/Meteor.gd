extends Area2D
class_name Meteor
#var path_meteor_sprite : String = "res://assets/PNG/Meteors/"
#up next: verifiy how much sprites have on the folder and catch one randomized

var array_meteor_sprite : Array = [
	"res://assets/PNG/Meteors/meteorBrown_big1.png",
	"res://assets/PNG/Meteors/meteorBrown_big2.png"
]

var life : int = 2 setget set_life

var move : Vector2
var speed : float

func _ready():
	randomize()
	var meteor_sprite : StreamTexture = load(array_meteor_sprite[randi() % array_meteor_sprite.size()])
	$Sprite.texture = meteor_sprite
	move.x = rand_range(-1, 1)
	move.y = rand_range(-1, 1)
	speed = rand_range(50, 100)

func set_life(value : int):
	life = value
	if life < 0:
		queue_free()

func _process(delta):
	translate(move * speed * delta)
	rotate(deg2rad(speed) * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
