extends Enemy

func _ready() -> void:
	hp_bar.init_health(max_hp, min_hp)
