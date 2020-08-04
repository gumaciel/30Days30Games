extends Node2D


var current_tile := "" setget set_current_tile

var visible_tile_time : float = 5
var actual_visible_tile_time : float = 0
var positions_taken := []

var tiles_complete := 0
var number_tiles := 0


func _ready():
	randomize()
	for i in $Tiles.get_child_count():
		$Tiles.get_child(i).position = _get_random_position()
	number_tiles = $Tiles.get_child_count()

func _get_random_position():
	var possible_position = $Positions.get_child((randi() % $Positions.get_child_count())).position
	if positions_taken.has(possible_position):
		return _get_random_position()
	else:
		positions_taken.append(possible_position)
		return possible_position

func _process(delta):
	actual_visible_tile_time += delta
	$Time.text = "Remaing time: " + str(int(visible_tile_time - actual_visible_tile_time))
	if actual_visible_tile_time >= visible_tile_time:
		for i in $Tiles.get_child_count():
			$Tiles.get_child(i).get_node("TextureButton").modulate = Color.black
			$Tiles.get_child(i).get_node("TextureButton").disabled = false
		set_process(false)

func set_current_tile(value : String):
	if current_tile == "":
		current_tile = value
		return
	else:
		if current_tile != value:
			for i in $Tiles.get_child_count():
				if !$Tiles.get_child(i).matched:
					$Tiles.get_child(i).back_normal_state()
		else:
			for i in $Tiles.get_child_count():
				if $Tiles.get_child(i).id == value:
					tiles_complete += 1
					$Tiles.get_child(i).disable_tile()
		current_tile = ""
	if tiles_complete >= number_tiles:
		$Time.text = "YOU WIN"


func _on_Button_pressed():
	get_tree().reload_current_scene()
