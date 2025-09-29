extends Node2D

const HOLE_FALL = preload("uid://cicvww20q6ri3")

const OGA_1 = preload("uid://bcokyv4txsgvb")
const OGA_2 = preload("uid://ucxjbckja51n")
const OGA_3 = preload("uid://b3cysbds6yduf")
const OGA_4 = preload("uid://bjl31501n2qho")
const OGA_5 = preload("uid://chf0cihf76o6h")

const PUNCH_1 = preload("uid://b62c0fh1vkcgm")
const PUNCH_2 = preload("uid://dnnmoeepho66n")
const PUNCH_3 = preload("uid://btaljmx8tr14b")
const PUNCH_4 = preload("uid://c4xaledt668ui")

const SMASH_1 = preload("uid://by0sjc5fgydvo")
const SMASH_2 = preload("uid://bfaby1dpf7ens")
const SMASH_3 = preload("uid://ojrqod2klskw")
const SMASH_4 = preload("uid://bdy4udtbakci4")

const BEAT_1 = preload("uid://dwvfp0vfbe4um")
const BEAT_2 = preload("uid://bwtku45k76vgt")
const BEAT_3 = preload("uid://dthblaqc7sws2")

const BOSS_JOEY_DOMAIN_1 = preload("uid://c7qs0wpl350o1")

const BOSS_JOEY_MANGA_1 = preload("uid://38rnnxakmhh5")
const BOSS_JOEY_MANGA_2 = preload("uid://ca3jfjyqwsgeb")

const BOSS_JOEY_SWORD_1 = preload("uid://x2aerki6sl85")
const BOSS_JOEY_SWORD_2 = preload("uid://dfgtahiyahrnd")
const BOSS_JOEY_SWORD_3 = preload("uid://dfn4cu0720iyn")

const CDAWG_MUMBLE_1 = preload("uid://bfmjen6al51l3")
const CDAWG_MUMBLE_2 = preload("uid://fb8cc31wecn6")
const CDAWG_MUMBLE_3 = preload("uid://cjc4vsolhya6v")

const GARNT_MUMBLE_1 = preload("uid://b0jckyicmvefj")
const GARNT_MUMBLE_2 = preload("uid://c3y07rfu2eaam")
const GARNT_MUMBLE_3 = preload("uid://0ftaw1uoxxh1")

const JOEY_MUMBLE_1 = preload("uid://nc6vcymcvppf")
const JOEY_MUMBLE_2 = preload("uid://ble5ha5nga6dp")

const MONKEY_MADNESS_1 = preload("uid://c4xcfs2xm1785")
const MONKEY_MADNESS_2 = preload("uid://cu35083oyeg4u")
const MONKEY_MADNESS_3 = preload("uid://b3mxjffvk4ayp")
const MONKEY_MADNESS_4 = preload("uid://dqr0fq8d1drjx")

const PAIN_1 = preload("uid://boscbms3atoyk")
const PAIN_2 = preload("uid://dso4h4o8nuoxe")
const PAIN_3 = preload("uid://buuar44ihceq3")

const PETE_MUMBLE_1 = preload("uid://ccau30cevyt8r")
const PETE_MUMBLE_2 = preload("uid://l6vu0bovq33b")
const PETE_MUMBLE_3 = preload("uid://bdyak5h620tv6")
const PETE_MUMBLE_4 = preload("uid://bfhufoholo4gg")
const PETE_MUMBLE_5 = preload("uid://crqjw62v4yqt2")


const audio_samples = {
	"MONKEY_MADNESS_1": MONKEY_MADNESS_1,
	"MONKEY_MADNESS_2": MONKEY_MADNESS_2,
	"MONKEY_MADNESS_3": MONKEY_MADNESS_3,
	"MONKEY_MADNESS_4": MONKEY_MADNESS_4,
	"BEAT_1": BEAT_1,
	"BEAT_2": BEAT_2,
	"BEAT_3": BEAT_3,
	
	"HOLE_FALL": HOLE_FALL,
	"PUNCH_1": PUNCH_1,
	"PUNCH_2": PUNCH_2,
	"PUNCH_3": PUNCH_3,
	"PUNCH_4": PUNCH_4,
	"OGA_1": OGA_1,
	"OGA_2": OGA_2,
	"OGA_3": OGA_3,
	"OGA_4": OGA_4,
	"OGA_5": OGA_5,
	"SMASH_1": SMASH_1,
	"SMASH_2": SMASH_2,
	"SMASH_3": SMASH_3,
	"SMASH_4": SMASH_4,
	"PAIN_1": PAIN_1,
	"PAIN_2": PAIN_2,
	"PAIN_3": PAIN_3,
	"BOSS_JOEY_SWORD_1": BOSS_JOEY_SWORD_1,
	"BOSS_JOEY_SWORD_2": BOSS_JOEY_SWORD_2,
	"BOSS_JOEY_SWORD_3": BOSS_JOEY_SWORD_3,
	"BOSS_JOEY_MANGA_1": BOSS_JOEY_MANGA_1,
	"BOSS_JOEY_MANGA_2": BOSS_JOEY_MANGA_2,
	"BOSS_JOEY_DOMAIN_1": BOSS_JOEY_DOMAIN_1,
	
	"CDAWG_MUMBLE_1": CDAWG_MUMBLE_1,
	"CDAWG_MUMBLE_2": CDAWG_MUMBLE_2,
	"CDAWG_MUMBLE_3": CDAWG_MUMBLE_3,
	"JOEY_MUMBLE_1": JOEY_MUMBLE_1,
	"JOEY_MUMBLE_2": JOEY_MUMBLE_2,
	"PETE_MUMBLE_1": PETE_MUMBLE_1,
	"PETE_MUMBLE_2": PETE_MUMBLE_2,
	"PETE_MUMBLE_3": PETE_MUMBLE_3,
	"PETE_MUMBLE_4": PETE_MUMBLE_4,
	"PETE_MUMBLE_5": PETE_MUMBLE_5,
	"GARNT_MUMBLE_1": GARNT_MUMBLE_1,
	"GARNT_MUMBLE_2": GARNT_MUMBLE_2,
	"GARNT_MUMBLE_3": GARNT_MUMBLE_3,
}


func play_audio(audio_file, attach_location: Node = null, audio_bus: String = "Master", volume := 1.0, follow_up: String = ""):
	if audio_samples[audio_file]:
		var new_player = AudioStreamPlayer2D.new()
		
		if attach_location == null:
			add_child(new_player)
		else:
			attach_location.add_child(new_player)
		
		new_player.bus = audio_bus
		new_player.volume_linear = volume
		new_player.stream = audio_samples[audio_file]
		new_player.finished.connect(new_player.queue_free)
		new_player.add_to_group("audio")
		
		if audio_file.contains("MONKEY_MADNESS_"):
			new_player.pitch_scale = Global.rng.randf_range(0.75, 0.9)
		if audio_file.contains("BEAT_"):
			new_player.pitch_scale = Global.rng.randf_range(0.75, 1.35)
		if audio_file.contains("HOLE_FALL"):
			new_player.volume_linear = 3
		if audio_file.contains("OGA_3"):
			new_player.volume_linear = 3
		
		new_player.play()
		
		if follow_up:
			await new_player.finished
			play_audio(follow_up, attach_location, audio_bus, volume)
		elif audio_file.contains("BEAT_"):
			await new_player.finished
			play_audio(audio_file, attach_location, audio_bus, volume)

func kill_all():
	get_tree().get_nodes_in_group("audio").all(func(node): node.queue_free())
