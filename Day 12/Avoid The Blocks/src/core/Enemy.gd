extends Area


var speed : int = 10

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	translate(Vector3.BACK * speed * delta) 


func _on_Enemy_area_entered(area : Spatial):
	area.queue_free()
	get_parent().game_over()
