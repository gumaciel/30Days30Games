extends Area2D

signal won


func _ready():
	pass # Replace with function body.


func _on_Cat_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("won")
