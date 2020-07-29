extends Node2D

class_name Game

var pre_food = preload("res://src/food/Food.tscn")

var points := 0 setget set_points

var alive := true setget set_alive

func _ready():
	randomize()

func set_alive(value : bool):
	alive = value
	if alive == false:
		pass
		
func set_points(value : int):
	points = value
	$Control/Score.text = str(points)

	var food = pre_food.instance()
	
	var new_position := Vector2(randi() % 22 + 1, randi() % 32)

	food.position = new_position
	
	add_child(food)
