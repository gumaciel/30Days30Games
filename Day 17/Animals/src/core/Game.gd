extends Control


var animals_collection = [preload("res://src/actors/Bear.tscn"), preload("res://src/actors/Cat.tscn")]
var actual_animal = 0

func _ready():
	$AnimalPosition.add_child(animals_collection[actual_animal].instance())


func _on_NextButton_pressed():
	$AnimalPosition.remove_child($AnimalPosition.get_child(0))
	actual_animal += 1
	if animals_collection.size() <= actual_animal:
		actual_animal = 0
	$AnimalPosition.add_child(animals_collection[actual_animal].instance())
