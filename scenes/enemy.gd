extends CharacterBody2D
class_name Enemy

@export var max_hp = 100
@onready var hp = max_hp

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hp_bar: ProgressBar = $HPBar

func apply_damage():
	#print(hp, max_hp)
	hp = max(0, hp - 20)
	hp_bar.health = hp
	if hp == 0:
		collision_shape_2d.set_deferred("disabled", true)
		# play animation and die
		pass
