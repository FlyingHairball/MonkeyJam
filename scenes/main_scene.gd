extends Node2D
@onready var bg_tutorial: Sprite2D = $ParallaxBackground/ParallaxLayer/BgTutorial
@onready var parallax_layer: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var boss_joey: CharacterBody2D = $BossJoey
@onready var end_marker_2d: Marker2D = $EndMarker2D
@onready var credits_marker: Marker2D = $CreditsMarker
@onready var main_screen: Control = $MainScreen
@onready var continue_button: Button = $MainScreen/Sprite2D/ContinueButton

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
var pete_convo_ended = false
@onready var pete: Node2D = $Pete
@onready var pete_text_box: Control = $PeteTextBox

@onready var pete_convo = [
	[pete_text_box, "Suuuuh Duuude!"],
	[player_text_box, "Pete! hey buddy ol pal!"],
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

@onready var checkpoint_1: Marker2D = $Checkpoints/Checkpoint1
@onready var checkpoint_2: Marker2D = $Checkpoints/Checkpoint2

var game_won = false
@onready var full_screen: Label = $MainScreen/FullScreen
@onready var fullscreen_animation_player: AnimationPlayer = $MainScreen/FullscreenAnimationPlayer

func _ready() -> void:
	fullscreen_animation_player.play("shake")
	if OS.has_feature("web"):
		full_screen.visible = true
	else:
		full_screen.visible = false
	if Global.menu:
		Global.intro_count += 1
		if Global.intro_count >= 10:
			AudioManager.play_audio("MONKEY_MADNESS_4", character_body_2d, "Music", 1.0, "BEAT_1")
		else:
			AudioManager.play_audio("MONKEY_MADNESS_" + str(Global.rng.randi_range(1,3)), character_body_2d, "Music", 1.0, "BEAT_1")
	
	match Global.checkpoint:
		0:
			if Global.menu:
				main_screen.visible = true
				character_body_2d.player_disabled = true
				continue_button.disabled = true
			else:
				main_screen.visible = false
				AudioManager.play_audio("BEAT_3", character_body_2d, "Music", 1.0)
		1:
			if Global.menu:
				main_screen.visible = true
				character_body_2d.player_disabled = true
			else:
				AudioManager.play_audio("BEAT_3", character_body_2d, "Music", 1.0)
				character_body_2d.global_position = checkpoint_1.global_position
				main_screen.visible = false
				#hide menues
		2:
			if Global.menu:
				main_screen.visible = true
				character_body_2d.player_disabled = true
			else:
				AudioManager.play_audio("BEAT_2", character_body_2d, "Music", 1.0)
				character_body_2d.global_position = checkpoint_2.global_position
				main_screen.visible = false
				
				joey_fight = true
				joey_fight_started = true
				joey_fight_ended = true
				joey_defeat_convo_ended = true
				
				boss_joey.queue_free()
				character_body_2d.skills.append("Joey")
				joey_convo.clear()
				joey_defeat_convo.clear()

func _process(_delta: float) -> void:
	if character_body_2d.global_position.x >= start and character_body_2d.global_position.x <= end:
		parallax_layer.modulate.a = 1 - ((character_body_2d.global_position.x - start) / (end - start))
	elif character_body_2d.global_position.x > end:
		parallax_layer.modulate.a = 0
	if character_body_2d.global_position.x >= start_desert and character_body_2d.global_position.x <= end_desert:
		parallax_layer_2.modulate.a = 1 - ((character_body_2d.global_position.x - start_desert) / (end_desert - start_desert))
	elif character_body_2d.global_position.x > end_desert:
		parallax_layer_2.modulate.a = 0
	if Global.checkpoint != 0 and character_body_2d.global_position.x > end_marker_2d.global_position.x:
		game_won = true
		character_body_2d.global_position = credits_marker.global_position
		Global.checkpoint = 0
	
	if Global.checkpoint < 1 and not game_won and character_body_2d.global_position.x > checkpoint_1.global_position.x:
		character_body_2d.update_health(character_body_2d.max_health)
		Global.checkpoint = max(Global.checkpoint, 1)
	if Global.checkpoint < 2 and not game_won and character_body_2d.global_position.x > checkpoint_2.global_position.x:
		character_body_2d.update_health(character_body_2d.max_health)
		Global.checkpoint = max(Global.checkpoint, 2)
	
	if !joey_fight and character_body_2d.position.x >= joey_trigger.position.x:
		print("trigger joey")
		joey_fight = true
		AudioManager.kill_all()
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
			AudioManager.play_audio("BEAT_2", character_body_2d, "Music", 1.0)
			
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
		elif not pete_convo_ended:
			pete_convo_ended = true
			pete.abduction()


func _on_pete_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		print(body)
		in_pete_zone = true


func _on_pete_area_body_exited(body: Node2D) -> void:
	if body.has_method("take_damage"):
		in_pete_zone = false


func _on_new_game_button_pressed() -> void:
	Global.checkpoint = 0
	Global.menu = false
	get_tree().reload_current_scene()


func _on_continue_button_pressed() -> void:
	Global.menu = false
	get_tree().reload_current_scene()


func _on_settings_button_pressed() -> void:
	character_body_2d.get_node("Camera2D/Interface/SettingsPanel").visible = true
