extends Camera2D

@export var max_offset: Vector2 = Vector2(500, 100)
@export var max_rotation: float = 0.06
@export var decay: float = 2.5

var trauma: float = 0.0
var _time: float = 0.0
var _noise := FastNoiseLite.new()

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
		offset = Vector2(ox, oy)
		rotation = max_rotation * _noise.get_noise_2d(_time, _time * 2.0) * t
	else:
		offset = Vector2.ZERO
		rotation = 0.0

func shake(kick: float = 0.4) -> void:
	trauma = clamp(trauma + kick, 0.0, 1.0)
