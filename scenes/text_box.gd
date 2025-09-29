extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
@export var voice: String
@export var voice_lines_number = 1

func play_text(text):
	visible = true
	label.text = text
	animation_player.play("animate_text")
	if voice:
		AudioManager.play_audio(voice + str(Global.rng.randi_range(1,voice_lines_number)), self, "Voice", 1.0)
