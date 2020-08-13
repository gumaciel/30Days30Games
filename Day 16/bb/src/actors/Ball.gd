extends Sprite

var speed = 1000

func _ready():
	set_process(false)

func _process(delta):
	translate(Vector2.UP * speed * delta)


func _on_Area2D_area_entered(area : Area2D):
	pass
