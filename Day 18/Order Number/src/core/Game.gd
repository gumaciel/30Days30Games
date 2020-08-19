extends Node2D


var numbers = [1, 5, 10, 24, 53, 107]
var aux_numbers = numbers.duplicate()
var pre_number = preload("res://src/core/Number.tscn")

var number_to_check = []
var time : float = 0.0

func _ready():
	randomize()
	for i in range(0, numbers.size()):
		$Label.text += str(numbers[i]) 
		if i+1 < numbers.size():
			$Label.text += "| "
		var number : Button = pre_number.instance(PackedScene.GEN_EDIT_STATE_DISABLED)
		number.rect_global_position = $Positions.get_child(i).position
		number.text = str(random_number())
		number.connect("pressed", self, "_on_Number_pressed", [number.text, number])
		add_child(number)
		
func _process(delta):
	time += delta

func random_number():
	
	var random_position = randi() % aux_numbers.size()
	
	var return_value = aux_numbers[random_position]
	aux_numbers.remove(random_position)
	return return_value


func _on_Number_pressed(value, node):
	node.disabled = true
	number_to_check.append(int(value))

func _on_Submit_pressed():
	$Submit.disabled = true
	set_process(false)
	var win = false
	if number_to_check.size() >= 1:
		win = true
		for i in range(0, number_to_check.size()):
			if number_to_check[i] != numbers[i]:
				win = false
				break
			
	if win:
		$Status.modulate = Color.green
		$Status.text = "WIN, TIME: " + str(time)
	else:
		$Status.modulate = Color.red
		$Status.text = "LOSE"
	$Timer.start()


func _on_Timer_timeout():
	get_tree().reload_current_scene()
