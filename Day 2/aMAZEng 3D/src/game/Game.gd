extends Spatial

class_name Game

var crystal_colleted := false setget set_crystal_colleted
var time : float = 0

func _ready():
	randomize()
	$Crystal.translation = $PossibleCrystalPositions.get_child(randi() % $PossibleCrystalPositions.get_child_count()).translation

func _process(delta):
	time += delta

func set_crystal_colleted(value: bool):
	crystal_colleted = value
	if value == true:
		$Hud/WonContainer/VBoxContainer/TimeLabel.text = "Your time is: " + str(time)
		$Hud/WonContainer/AnimationPlayer.play("won")
		if OS.get_name() == "Android" or OS.get_name() == "iOS":
			$Hud/WonContainer/VBoxContainer/Click.visible = true
		else:
			$Hud/WonContainer/VBoxContainer/Press.visible = true
		$Hud/WonContainer.visible = true

func _input(event : InputEvent):
	if event.is_action_pressed("restart") and crystal_colleted:
		var game = load("res://src/game/Game.tscn").instance()
		queue_free()
		get_tree().root.add_child(game)
