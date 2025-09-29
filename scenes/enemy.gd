extends CharacterBody2D
class_name Enemy

var colliding_obj = true

@export var max_hp = 100
@onready var hp = max_hp

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hp_bar: ProgressBar = $HPBar
@onready var sprite_2d: Sprite2D = $Sprite2D


@export var max_offset: Vector2 = Vector2(500, 100)
@export var max_rotation: float = 0.06
@export var decay: float = 2.5

@export var dead_texture: Texture2D = null

var trauma: float = 0.0
var _time: float = 0.0
var _noise := FastNoiseLite.new()
var dead = false
var death_rot = 0

func _ready() -> void:
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noise.frequency = 4.0

func _process(delta: float) -> void:
	_time += delta
	if trauma > 0.0:
		trauma = max(trauma - decay * delta, 0.0)
		var t := trauma * trauma
		
		var ox := max_offset.x * _noise.get_noise_2d(_time, 0.0) * t
		var oy := max_offset.y * _noise.get_noise_2d(0.0, _time) * t
		sprite_2d.position = Vector2(ox, oy)
		sprite_2d.rotation = deg_to_rad(death_rot * 90) + (max_rotation * _noise.get_noise_2d(_time, _time * 2.0) * t)
	else:
		sprite_2d.position = Vector2.ZERO
		sprite_2d.rotation = deg_to_rad(death_rot * 90)

func shake(kick: float = 0.4) -> void:
	trauma = clamp(trauma + kick, 0.0, 1.0)

func apply_damage():
	#print(hp, max_hp)
	hp = max(0, hp - 20)
	hp_bar.health = hp
	if hp == 0:
		dead = true
		death_rot = Global.rng.randf_range(-1,1)
		set_collision_layer_value(1, false)
		if dead_texture:
			sprite_2d.texture = dead_texture
		# play animation and die
		pass
