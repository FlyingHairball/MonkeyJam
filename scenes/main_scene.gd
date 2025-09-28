extends Node2D
@onready var bg_tutorial: Sprite2D = $ParallaxBackground/ParallaxLayer/BgTutorial
@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var boss_joey: CharacterBody2D = $BossJoey

var start = 7300.0
var end = 7900.0

var joey_fight = false
var joey_fight_started = false
var joey_fight_ended = false
var joey_defeat_convo_ended = false
@onready var joey_trigger: Marker2D = $JoeyTrigger
@onready var camera_pos: Marker2D = $CameraPos

@onready var player_text_box: Control = $PlayerTextBox
@onready var joey_text_box: Control = $JoeyTextBox

@onready var joey_convo = [
	[joey_text_box, "Leave me Alone!"],
	[player_text_box, "Let's go back to civilization."],
	[joey_text_box, "I can't go back, back... to watching anime"],
	[joey_text_box, "Leave me here"],
	[player_text_box, "You know I can't do that, Please come with me"],
	[joey_text_box, "Well, if words wont work, then maybe this will."],
]

@onready var joey_defeat_convo = [
	[joey_text_box, "Please, I don't want to watch anymore anime!"],
	[player_text_box, "I'm not here for that."],
	[joey_text_box, "What? then why are you here?"],
	[player_text_box, "I dont care if you watch anime or not"],
	[player_text_box, "I just want My friend back."],
	[joey_text_box, "Really"],
	[player_text_box, "Come, Lets go find Garnt."],
]

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if character_body_2d.global_position.x >= start and character_body_2d.global_position.x <= end:
		parallax_layer.modulate.a = 1 - ((character_body_2d.global_position.x - start) / (end - start))
	elif character_body_2d.global_position.x > end:
		parallax_layer.modulate.a = 0
	
	if !joey_fight and character_body_2d.position.x >= joey_trigger.position.x:
		print("trigger joey")
		joey_fight = true
		character_body_2d.player_disabled = true
		character_body_2d.global_position = joey_trigger.global_position
		character_body_2d.get_node("Camera2D").global_position = camera_pos.global_position
		character_body_2d.get_node("BodySprite").scale.x = abs(character_body_2d.get_node("BodySprite").scale.x)
		player_text_box.play_text("Joey! what are you doing in this Jungle?")
	
	if Input.is_action_just_pressed("interact") and joey_fight:
		player_text_box.visible = false
		joey_text_box.visible = false
		if len(joey_convo):
			var convo = joey_convo.pop_front()
			convo[0].play_text(convo[1])
		elif not joey_fight_started:
			joey_fight_started = true
			character_body_2d.player_disabled = false
			boss_joey.disabled = false
			
	if not joey_defeat_convo_ended and boss_joey.hp == 0:
		if Input.is_action_just_pressed("interact"):
			player_text_box.visible = false
			joey_text_box.visible = false
			if len(joey_defeat_convo):
				var convo = joey_defeat_convo.pop_front()
				convo[0].play_text(convo[1])
			elif not joey_defeat_convo_ended:
				joey_defeat_convo_ended = true
				boss_joey.queue_free()
				(character_body_2d.skills as Array).append("Joey")
	# center text boxes
	player_text_box.global_position.x = character_body_2d.global_position.x - 155.0
	if boss_joey:
		joey_text_box.global_position.x = boss_joey.global_position.x - 155.0
