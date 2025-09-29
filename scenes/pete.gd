extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d_2: Sprite2D = $Sprite2D2


func _ready() -> void:
	sprite_2d_2.visible = false

func abduction():
	animation_player.play("abduction")
