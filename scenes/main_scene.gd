extends Node2D
@onready var bg_tutorial: Sprite2D = $ParallaxBackground/ParallaxLayer/BgTutorial
@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var boss_joey: CharacterBody2D = $BossJoey
@onready var end_marker_2d: Marker2D = $EndMarker2D
@onready var credits_marker: Marker2D = $CreditsMarker

var start = 7300.0
var end = 7900.0

var start_desert = 20000.0
var end_desert = 20680.0

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


var in_pete_zone = false
@onready var pete: Node2D = $Pete
@onready var pete_text_box: Control = $PeteTextBox

@onready var pete_convo = [
	[pete_text_box, "Suuuuh Duuude!"],
	[player_text_box, "Hi Pete"],
	[player_text_box, "Have you seen Garnt Lately"],
	[pete_text_box, "Duuuuuude"],
	[pete_text_box, "You wont believe what just happened"],
	[pete_text_box, "I was dungeon diving with this one dude I met at the bar last night"],
	[player_text_box, "Pete please, I dont have time"],
	[pete_text_box, "Dont worry, it's a quick story"],
	[pete_text_box, "As I was Saying, We were diving this GNARLY dungeon, duuude"],
	[pete_text_box, "it was like goooold all over man"],
	[player_text_box, "pete..."],
	[pete_text_box, "We found this crazy cursed relic, mann"],
	[pete_text_box, "It was glowing a deep bloody red, and had a buch of ghosts an stuff"],
	[pete_text_box, "Most cursed thing I've ever laid my eye upon, straight up"],
	[pete_text_box, "And I've seen a looooot of stuff"],
	[player_text_box, "Please tell me you didn't touch it..."],
	[pete_text_box, "Nah duuude, I would never"],
	[pete_text_box, "But this guy I was with just wouldn't listen"],
	[player_text_box, "Oh God... so what happned to him"],
	[pete_text_box, "Well actually nothing, he's doing just fine"],
	[player_text_box, "What?"],
	[pete_text_box, "Yea, we accidentally pumped into Garnt on our way back"],
	[pete_text_box, "and he happened to pick up the cursed item"],
	[player_text_box, "WHAT! Start with that next time!!!"],
	[pete_text_box, "He ran away with it and started talking about enlightenment and becoming a god n stuff"],
	[player_text_box, "Hold on Garnt, We're Coming for you!"],
	[player_text_box, "..."],
	[player_text_box, "I mean, Coming to SAVE YOU! SAVE YOU!"],
]

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if character_body_2d.global_position.x >= start and character_body_2d.global_position.x <= end:
		parallax_layer.modulate.a = 1 - ((character_body_2d.global_position.x - start) / (end - start))
	elif character_body_2d.global_position.x > end:
		parallax_layer.modulate.a = 0
	if character_body_2d.global_position.x >= start_desert and character_body_2d.global_position.x <= end_desert:
		parallax_layer_2.modulate.a = 1 - ((character_body_2d.global_position.x - start_desert) / (end_desert - start_desert))
	elif character_body_2d.global_position.x > end_desert:
		parallax_layer_2.modulate.a = 0
	if character_body_2d.global_position.x > end_marker_2d.global_position.x:
		character_body_2d.global_position = credits_marker.global_position
		
	
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
	if pete:
		pete_text_box.global_position.x = pete.global_position.x - 155.0
	
	
	if in_pete_zone and Input.is_action_just_pressed("interact"):
		player_text_box.visible = false
		pete_text_box.visible = false
		if len(pete_convo):
			var convo = pete_convo.pop_front()
			convo[0].play_text(convo[1])
		else:
			# get abduted by aliens, concentually
			pass


func _on_pete_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		print(body)
		in_pete_zone = true


func _on_pete_area_body_exited(body: Node2D) -> void:
	if body.has_method("take_damage"):
		in_pete_zone = false
