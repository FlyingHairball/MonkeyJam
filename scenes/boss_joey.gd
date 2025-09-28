extends Enemy

var disabled = true : set = _set_disabled
var previous_move = 0
var current_move = 0
var moves = ["sword", "manga", "jump"]
var acting = false
var air_time = false

@onready var sword_collision: CollisionShape2D = $HitArea/SwordCollision
const MANGA = preload("uid://d1rrso4wiig20")
@onready var domain_collision: CollisionShape2D = $HitArea/DomainCollision
@onready var domain: Sprite2D = $HitArea/DomainCollision/Domain
@onready var domain_timer: Timer = $DomainTimer
@onready var Interaction_collision_shape_2d: CollisionShape2D = $InteractionArea2D/CollisionShape2D


@onready var joey_interaction: Label = $JoeyInteraction

func _set_disabled(new_value):
	disabled = new_value
	#dead = true
	print("disabled?")
	if not disabled:
		act()

func _ready() -> void:
	hp_bar.init_health(max_hp)

func _physics_process(delta: float) -> void:
	if disabled:
		return
	
	if not is_on_floor() and not air_time:
		velocity += get_gravity() * delta
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func act():
	if dead:
		joey_interaction.show()
		Interaction_collision_shape_2d.disabled = false
		return

	var move = moves[current_move]
	var players = get_tree().get_nodes_in_group("player")
	if len(players):
		var player_pos = players[0].global_position
		match move:
			"sword":
				var distance = global_position - player_pos
				var target_pos = global_position - (distance * 1.5)
				var direction = -1 if distance.x > 0 else 1
				sprite_2d.scale.x = abs(sprite_2d.scale.x) * direction
				tween_angle(25 * direction, 0.1)
				await get_tree().create_timer(0.3).timeout
				sword_collision.disabled = false
				tween_sword(target_pos)
			"manga":
				air_time = true
				tween_position(player_pos + Vector2(0, -900), 0.5).connect(spawn_mangas.bind(player_pos))
			"jump":
				domain_timer.start()
				recur_tween(1)
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

func tween_position(target_position: Vector2, tween_time: float = 0.2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_position, tween_time)
	return tween.finished

func spawn_mangas(player_pos):
	await get_tree().create_timer(0.3).timeout
	spawn_manga(player_pos + Vector2(0, -750))
	spawn_manga(player_pos + Vector2(500, -750))
	spawn_manga(player_pos + Vector2(-500, -750))
	next_move()

func spawn_manga(target_position):
	var manga_intance = MANGA.instantiate()
	manga_intance.global_position = target_position
	manga_intance.top_level = true
	add_child(manga_intance)
	pass

func recur_tween(show_color: bool):
	if domain_timer.time_left:
		tween_domain_vis(show_color, domain_timer.time_left * 0.1).connect(recur_tween.bind(not show_color))

func tween_domain_vis(target_opacity: bool, tween_time: float = 0.2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(domain, "modulate", Color("ffffff" if target_opacity else "ffffff00"), tween_time)
	return tween.finished

func tween_domain_scale(target_scale: Vector2, tween_time: float = 0.2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(domain_collision, "scale", target_scale, tween_time)
	return tween.finished

func _on_domain_timer_timeout() -> void:
	domain.modulate = Color("ffffff")
	domain_collision.disabled = false
	tween_domain_scale(Vector2(4,4), 0.3).connect(domain_cooldown)

func domain_cooldown():
	domain_collision.disabled = true
	tween_domain_vis(0, 1).connect(next_move)

func next_move():
	# reset sword
	tween_angle(0, 0.3)
	sword_collision.disabled = true
	
	# reset manga
	air_time = false
	
	# reset domain
	domain_collision.scale = Vector2(1,1)
	
	# downtime and generate next move
	await get_tree().create_timer(2).timeout
	while current_move == previous_move:
		current_move = randi_range(0,2)
	previous_move = current_move
	act()

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		body.apply_recoil(0.4)


func _on_interaction_area_2d_body_entered(_body: Node2D) -> void:
	joey_interaction.show()


func _on_interaction_area_2d_body_exited(_body: Node2D) -> void:
	joey_interaction.hide()
