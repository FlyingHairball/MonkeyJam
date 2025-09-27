extends Node

var slowmo_active = false

@export var normal_time_scale: float = 1.0
@export var slowmo_time_scale: float = 0.1

func tween_slowmo(time_scale, time := 0.5):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(Engine, "time_scale", time_scale, time)

func start_slowmo():
	tween_slowmo(slowmo_time_scale)
	#Engine.time_scale = slowmo_time_scale
	slowmo_active = true

func stop_slowmo():
	tween_slowmo(normal_time_scale)
	#Engine.time_scale = normal_time_scale
	slowmo_active = false
