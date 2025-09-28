extends Sprite2D

@export var speed = 5000.0
@export var init_pos = Vector2.ZERO
@export var parent_context = CharacterBody2D

func _ready() -> void:
	global_position = init_pos

func _physics_process(delta: float) -> void:
	position.x += speed * delta

func _on_timeout_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("StaticBody2D"):
		parent_context.apply_recoil()
		AudioManager.play_audio("SMASH_" + str(randi_range(1,2)), parent_context, 0.4)
		queue_free()
	if "colliding_obj" in body and body.colliding_obj == true:
		if body.has_method("apply_damage"):
			body.apply_damage()
			body.shake()
			AudioManager.play_audio("SMASH_" + str(randi_range(1,2)), parent_context, 0.4)
			if body.hp <= (body.max_hp * 0.2):
				parent_context.critical_hit(body.global_position)
		parent_context.apply_recoil(0.2)
