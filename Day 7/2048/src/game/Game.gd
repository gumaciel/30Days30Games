extends Control


var move : Vector2 setget set_move

var position_mouse : Vector2
var possible_positions := [
	Vector2(100, 100), 
	Vector2(300, 100), 
	Vector2(500, 100), 
	Vector2(700, 100), 
	
	Vector2(100, 300), 
	Vector2(300, 300), 
	Vector2(500, 300), 
	Vector2(700, 300), 
	
	Vector2(100, 500), 
	Vector2(300, 500), 
	Vector2(500, 500), 
	Vector2(700, 500), 
	
	Vector2(100, 700), 
	Vector2(300, 700), 
	Vector2(500, 700), 
	Vector2(700, 700), 
	]
	
var pre_number = preload("res://src/game/Number.tscn")
func _ready():
	_add_number()

func _on_Game_gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		var mouse = (event as InputEventMouse)
		if mouse.button_index == BUTTON_LEFT:
			if mouse.is_pressed():
				position_mouse = mouse.position
			else:
				position_mouse = (position_mouse - mouse.position).normalized().round()
				if position_mouse == Vector2.UP or position_mouse == Vector2.DOWN or position_mouse == Vector2.LEFT or position_mouse == Vector2.RIGHT:
					self.move = position_mouse * -1
					_add_number()

func _add_number(number_value : String = "2", number_position : Vector2 = possible_positions[randi() % possible_positions.size()]):
	var number = pre_number.instance()
	number.number_value = number_value
	number.position = number_position
	number.connect("number_value_changed", self, "_on_number_value_changed", [number])
	$Numbers.add_child(number)

func _on_number_value_changed(new_value : String, collider : Number, self_number : Number):
	collider.queue_free()
	self_number.queue_free()
	_add_number(new_value, collider.position)
	self.move = move
	

func set_move(value : Vector2):
	move = value
	for i in $Numbers.get_child_count():
		($Numbers.get_child(i) as Number).new_position = move
