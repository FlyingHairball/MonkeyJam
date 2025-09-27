extends ProgressBar

@export var color = Color("2c6a30")
@export var enemy_critical_color = Color("aa0d00")
@export var is_enemy = true

@onready var damage_timer: Timer = $DamageTimer
@onready var damage_bar: ProgressBar = $DamageBar

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health

	if health < prev_health:
		damage_timer.start()
		if is_enemy and health < (max_value * 0.2):
			(get_theme_stylebox("fill") as StyleBoxFlat).bg_color = enemy_critical_color
	else:
		damage_bar.value = health

func init_health(_health, min_health := 0):
	max_value = _health
	min_value = min_health
	health = _health
	value = _health
	damage_bar.max_value = health
	damage_bar.value = health
	var box = StyleBoxFlat.new()
	box.bg_color = color
	add_theme_stylebox_override("fill", box)
	#(get_theme_stylebox("fill") as StyleBoxFlat).bg_color = color


func _on_damage_timer_timeout() -> void:
	damage_bar.value = health
