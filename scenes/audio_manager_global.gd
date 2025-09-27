extends Node2D
const HOLE_FALL = preload("uid://c0yulfb1j2u7s")
const PUNCH_1 = preload("uid://cdbndn2eg1q82")
const PUNCH_2 = preload("uid://dty4qxnw6m6i6")
const PUNCH_3 = preload("uid://cayi16p3dcnkg")
const PUNCH_4 = preload("uid://5wa6wmfsufyx")
const OGA_1 = preload("uid://cp6dk3tvfevwa")
const OGA_2 = preload("uid://ci0awyb4f4daa")
const OGA_3 = preload("uid://bnnvrl0hih0u2")
const SMASH_1 = preload("uid://br8io7wxf2b3h")
const SMASH_2 = preload("uid://dtyu6ylgj7yno")
const SMASH_3 = preload("uid://dlgtj32uiq650")

const audio_samples = {
	"HOLE_FALL": HOLE_FALL,
	"PUNCH_1": PUNCH_1,
	"PUNCH_2": PUNCH_2,
	"PUNCH_3": PUNCH_3,
	"PUNCH_4": PUNCH_4,
	"OGA_1": OGA_1,
	"OGA_2": OGA_2,
	"OGA_3": OGA_3,
	"SMASH_1": SMASH_1,
	"SMASH_2": SMASH_2,
	"SMASH_3": SMASH_3,
}

var punch_rando
var oga_rando

func play_audio(audio_file, attach_location: Node2D = null, volume := 1.0):
	if audio_samples[audio_file]:
		var new_player = AudioStreamPlayer2D.new()
		
		if attach_location == null:
			add_child(new_player)
		else:
			attach_location.add_child(new_player)
		
		new_player.stream = audio_samples[audio_file]
		new_player.volume_linear = volume
		new_player.finished.connect(new_player.queue_free)
		
		new_player.play()
