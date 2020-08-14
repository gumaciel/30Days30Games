extends Control


func _ready():
	$CenterContainer/VBoxContainer/Name.text = name


func _on_Body_pressed():
	$AudioStreamPlayer.play()
