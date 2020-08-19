extends KinematicBody2D

var last_direction = false
signal position_changed

func _ready():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("idle")

func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			var direction = false
			if ((event as InputEventMouseButton).global_position.x >= get_viewport().size.x / 2):
				direction = true
			else:
				direction = false
			
			if last_direction != direction:
				if direction:
					position.x += 300
					$Sprite.flip_h = true
				else:
					position.x += -300
					$Sprite.flip_h = false
				last_direction = direction
			$AnimationPlayer.play("attack")
			emit_signal("position_changed")
