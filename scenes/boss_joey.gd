extends Enemy

var disabled = true : set = _set_disabled
var current_move = 0
var moves = ["sword", "manga", "jump"]
var acting = false

@onready var sword_collision: CollisionShape2D = $HitArea/SwordCollision

func _set_disabled(new_value):
	disabled = new_value
	
	if not disabled:
		act()

func _ready() -> void:
	hp_bar.init_health(max_hp)

func _physics_process(delta: float) -> void:
	if disabled:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func act():
	if dead:
		return

	var move = moves[current_move]
	
	match move:
		"sword":
			var players = get_tree().get_nodes_in_group("player")
			if len(players):
				acting = true
				var player_pos = players[0].global_position
				var distance = global_position - player_pos
				var target_pos = global_position - (distance * 1.5)
				var direction = -1 if distance.x > 0 else 1
				sprite_2d.scale.x = abs(sprite_2d.scale.x) * direction
				tween_angle(25 * direction, 0.1)
				await get_tree().create_timer(0.3).timeout
				sword_collision.disabled = false
				tween_sword(target_pos)
			pass
		"manga":
			pass
		"jump":
			pass
	
	pass

func tween_angle(target_angle: int, tween_time: float = 0.2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation", deg_to_rad(target_angle), tween_time)

func tween_sword(target_position: Vector2, tween_time: float = 0.2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_position, tween_time)
	tween.finished.connect(next_move)

func next_move():
	tween_angle(0, 0.3)
	sword_collision.disabled = true
	await get_tree().create_timer(2).timeout
	acting = false
	current_move = randi_range(0,2)
	act()


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		body.apply_recoil(0.4)
