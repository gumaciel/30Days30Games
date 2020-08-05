extends KinematicBody


export(NodePath) var game_node_path
var game_node : Game = null

const SPEED := 5.0

var target = null
var navigation : Navigation = null
var velocity : Vector3

func _ready():
	game_node = get_node(game_node_path)

func _process(delta):
	look_at(game_node.get_node("Navigation/Player").transform.origin, Vector3.UP)


func _physics_process(delta):
	if target == null:
		return
		
	var path = get_path_to(target.global_transform.origin)
	
	if path.size() > 0:
		move_and_slide(path)
		
func get_path_to(target):
	return navigation.get_simple_path(global_transform.origin, target)
	
func move_along_path(path):
	if path.size() <= 0:
		return 
		
	path.remove(0)
	var target = path[0]

	if global_transform.origin.distance_to(target) < 0.1:
		path.remove(0)
		
	velocity = (target - translation).normalized() * SPEED
	
	velocity = move_and_slide(velocity)
	
func set_target(target):
	self.target = target
	
func set_nav(nav):
	self.navigation = nav
