extends Node2D


export(String) var id = "icon"
var matched := false

func _ready():
	$TextureButton.disabled = true

func _on_TextureButton_pressed():
	$TextureButton.disabled = true
	$TextureButton.modulate = Color.gray
	get_parent().get_parent().current_tile = id

func disable_tile():
	$TextureButton.modulate = Color.green
	matched = true

func back_normal_state():
	$TextureButton.disabled = false
	$TextureButton.modulate = Color.black
