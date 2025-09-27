extends Node

var controller_active = false


func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		controller_active = true
	elif (event is InputEventMouse or event is InputEventKey):
		controller_active = false
