extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label


func play_text(text):
	visible = true
	label.text = text
	animation_player.play("animate_text")
