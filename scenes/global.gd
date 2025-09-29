extends Node

var controller_active = false

var checkpoint = 0 : set = _set_checkpoint
var master = 1.0
var music = 1.0
var sfx = 1.0
var voice = 1.0


func _set_checkpoint(new_checkpoint):
	checkpoint = new_checkpoint
	session_store("checkpoint", checkpoint)

var menu = true

var intro_count = 0

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	checkpoint = int(session_get("checkpoint", 0))
	master = float(session_get("master", 1.0))
	music = float(session_get("music", 1.0))
	sfx = float(session_get("sfx", 1.0))
	voice = float(session_get("voice", 1.0))
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), master)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), music)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), sfx)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Voice"), voice)
	await get_tree().process_frame
	var settings = get_tree().get_nodes_in_group("settings")
	if len(settings) and settings[0].has_method("update_sliders"):
		settings[0].update_sliders()

func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		controller_active = true
	elif (event is InputEventMouse or event is InputEventKey):
		controller_active = false

func session_store(key, value):
	if OS.has_feature("web"):
		JavaScriptBridge.eval("sessionStorage.setItem('"+ key +"', '"+str(value)+"')")
	
	match key:
		"master":
			master = value
		"music":
			music = value
		"sfx":
			sfx = value
		"voice":
			voice = value

func session_get(key, default_val):
	if OS.has_feature("web"):
		var value = JavaScriptBridge.eval("sessionStorage.getItem('"+ key +"')", true)
		if value != null:
			return value
	return default_val
