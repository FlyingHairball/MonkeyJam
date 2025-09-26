extends Sprite2D

const SPEED = 5000.0
@export var init_pos = Vector2.ZERO
@export var parent_context = CharacterBody2D

func _ready() -> void:
	global_position = init_pos

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta

func _on_timeout_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("StaticBody2D"):
		parent_context.apply_recoil()
		queue_free()
	if body.is_class("CharacterBody2D"):
		if body.has_method("apply_damage"):
			body.apply_damage()
