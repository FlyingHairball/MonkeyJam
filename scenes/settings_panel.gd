extends Panel
@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/MasterSlider/HSlider
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MusicSlider/HSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SFXSlider/HSlider
@onready var voice_slider: HSlider = $MarginContainer/VBoxContainer/VoiceSlider/HSlider

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	update_sliders()

func update_sliders():
	master_slider.value = Global.master
	music_slider.value = Global.music
	sfx_slider.value = Global.sfx
	voice_slider.value = Global.voice

func _on_master_slider_value_changed(value: float) -> void:
	Global.session_store("master", value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_music_slider_value_changed(value: float) -> void:
	Global.session_store("music", value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func _on_sfx_slider_value_changed(value: float) -> void:
	Global.session_store("sfx", value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)


func _on_voice_slider_value_changed(value: float) -> void:
	Global.session_store("voice", value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Voice"), value)
