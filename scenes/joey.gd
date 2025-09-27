extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func animate():
	animation_player.play("arm_animation")
