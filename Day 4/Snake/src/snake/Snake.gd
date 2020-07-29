extends Node2D

var pre_body = preload("res://src/snake/Body.tscn")
var children : Array

var direction := Vector2.UP

var totalD=0

func _ready():
	pass

func _process(delta):
	totalD+=delta
	
	var axis := Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	if axis != Vector2.ZERO:
		if not (axis.x != 0 and axis.y != 0):
			if axis != -direction:
				direction = axis

	if totalD<.1:
		return
	totalD=0
	var last_position = position
	translate(direction)
	for i in range(children.size()-1, -1, -1):
		if i==0:
			children[0].translate(last_position - children[0].position)
		else:
			children[i].translate(children[i-1].position-children[i].position)
func earn_points():
	(get_parent() as Game).points += 1
	
	var body = pre_body.instance();
	body.position=self.position - direction
	children.append(body)
	get_parent().call_deferred("add_child", body)
