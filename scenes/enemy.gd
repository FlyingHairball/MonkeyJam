extends CharacterBody2D
class_name Enemy

@export var max_hp = 100
@export var min_hp = 0
@onready var hp = max_hp

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hp_bar: ProgressBar = $HPBar

func _ready() -> void:
	hp_bar.init_health(max_hp, min_hp)

func apply_damage():
	#print(hp, max_hp)
	hp = max(min_hp, hp - 20)
	hp_bar.health = hp
	if hp == 0:
		collision_shape_2d.set_deferred("disabled", true)
		# play animation and die
		pass
