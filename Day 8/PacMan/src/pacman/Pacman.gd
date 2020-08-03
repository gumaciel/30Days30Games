extends KinematicBody2D


export var speed := 100
var move := Vector2.RIGHT

func _ready():
	pass

func _physics_process(delta):
	move.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")) 
	move.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) 
	move_and_slide(move * speed)


func _on_Area2DFood_area_entered(area : Node2D):
	print(area.name)
	area.queue_free()
