extends Camera

onready var ball : Spatial = get_parent()
onready var translate_to_transform : Vector3


func _ready():
	set_as_toplevel(true)
	translate_to_transform = transform.origin
	
func _process(delta):
	transform.origin.x = ball.transform.origin.x + translate_to_transform.x
	transform.origin.y = ball.transform.origin.y + translate_to_transform.y
	transform.origin.z = ball.transform.origin.z + translate_to_transform.z
