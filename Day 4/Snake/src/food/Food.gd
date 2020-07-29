extends Area2D



func _ready():
	pass # Replace with function body.



func _on_Food_area_entered(area):
	area.get_parent().earn_points()
	queue_free()
	pass # Replace with function body.
