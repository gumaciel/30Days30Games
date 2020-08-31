extends Spatial


var can_shoot = true


func _ready():
	pass # Replace with function body.


func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and can_shoot:
			can_shoot = false
			$Particles.emitting = true
			$TimerToShootAgain.start()

func _on_TimerToShootAgain_timeout():
	can_shoot = true
	$Particles.emitting = false
