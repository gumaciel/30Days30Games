extends Node

var pre_meteor = preload("res://src/enemies/Meteor.tscn")

var going : Dictionary = {"x" : false, "y" : false}

func _on_Timer_timeout():
	var meteor = pre_meteor.instance()
	$Meteors.add_child(meteor)
