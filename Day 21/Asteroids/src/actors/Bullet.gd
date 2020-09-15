extends Area2D

class_name Bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var move : Vector2
var speed = 50

func _process(delta):
	print(move)
	translate(move * speed * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_area_entered(area : Meteor):
	area.life -= 1
	pass # Replace with function body.
