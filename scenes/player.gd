extends CharacterBody2D

@export var health = 300
@export var skill = 100
@export var skilling = 5
var skills = ["Nothing"]
var selected_skill = 0
var skill_charge = 0
var skill_active = false
var hyper_mode_active = false
var enemy_pos = null
var max_hyper_mode_extra_timer = 0.35

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const RECOIL_DECAY = 5000.0
const RECOIL_STRENGTH = 200.0
const RECOIL_MAX = 600.0

var recoil: Vector2 = Vector2.ZERO

@onready var camera_2d: Camera2D = $Camera2D

@onready var attck_guide: Sprite2D = $AttckGuide
@onready var attack_area_collision_shape_2d: CollisionShape2D = $AttackArea/CollisionShape2D

const ATTACK = preload("uid://b8om57bg2wadu")
const JOEY = preload("uid://cnjjsngdkmi5e")
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var joey_timer: Timer = $JoeyTimer
var joey_mode = false
var joey_pos = Vector2.ZERO
@onready var joey_instance = JOEY.instantiate()

@onready var hp_bar: ProgressBar = $Camera2D/Interface/InterfaceBG/HPBar
@onready var skill_bar: ProgressBar = $Camera2D/Interface/InterfaceBG/SkillBar
@onready var invincibility_timer: Timer = $InvincibilityTimer

@onready var body_sprite: Sprite2D = $BodySprite
@onready var eyelid_sprite: Sprite2D = $BodySprite/HeadSprite/EyelidSprite
@onready var interface_face_angry_sprite: Sprite2D = $Camera2D/Interface/InterfaceBG/InterfaceFaceSprite/InterfaceFaceAngrySprite

@onready var slowmo_controller: Node = $SlowmoController
@onready var slowmo_timer: Timer = $SlowmoTimer

var lerp_cam_pos_fator = 0.05

var is_falling = false

var time = 0
var clicks_per_second = 0
@onready var speed_lines: ColorRect = $Camera2D/SpeedLines


var player_disabled = false

func _ready() -> void:
	eyelid_sprite.visible = false
	interface_face_angry_sprite.visible = false
	hp_bar.init_health(health)
	skill_bar.init_health(skill)
	skill_bar.health = skill_charge

func _process(delta: float) -> void:
	if player_disabled:
		return
	
	
	time += delta
	if time >= 0.05 and clicks_per_second > 0:
		clicks_per_second -= 1
		time = 0
	speed_lines.material.set_shader_parameter("line_density", clicks_per_second / 30.0)
	
	
	if not hyper_mode_active:
		camera_2d.global_position.x = position.x
		camera_2d.global_position.y = min(360.0, position.y)
	elif joey_mode:
		camera_2d.global_position.x = lerp(camera_2d.global_position.x, joey_pos.x, lerp_cam_pos_fator)
		camera_2d.global_position.y = lerp(camera_2d.global_position.y, joey_pos.y, lerp_cam_pos_fator)
	else:
		camera_2d.global_position.x = lerp(camera_2d.global_position.x, position.x + ((enemy_pos.x - position.x) / 2), lerp_cam_pos_fator)
		camera_2d.global_position.y = lerp(camera_2d.global_position.y, position.y, lerp_cam_pos_fator)

func _physics_process(delta: float) -> void:
	if player_disabled:
		return
	
	
	if recoil and not hyper_mode_active:
		velocity += recoil
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor() and !recoil:
		velocity = Vector2.ZERO
	
	if not is_falling and global_position.y > 800:
		is_falling = true
		AudioManager.play_audio("HOLE_FALL", camera_2d)
	
	if (Input.is_action_just_pressed("switch_skill") or Input.is_action_just_pressed("con_switch_skill")):
		selected_skill += 1
		if selected_skill == len(skills):
			selected_skill = 0
		$Camera2D/Interface/InterfaceBG/tempSkill.text = skills[selected_skill]
	
	if (Input.is_action_just_pressed("jump") or
	Input.is_action_just_pressed("jump2") or
	Input.is_action_just_pressed("con_jump")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("left", "right")
	if Global.controller_active: direction = Input.get_axis("con_left", "con_right")
	if direction:
		position.x += direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var angle = get_angle()
	if angle != null:
		attck_guide.rotation = angle
	
	if (Input.is_action_just_pressed("attack") or
	Input.is_action_just_pressed("con_attack")) and (attack_cooldown.is_stopped() or hyper_mode_active):
		attack_cooldown.start()
		attack()
	#if recoil:
		#print(recoil)
	move_and_slide()
	recoil = recoil.move_toward(Vector2.ZERO, RECOIL_DECAY * delta)
	
	if skill_active or hyper_mode_active:
		interface_face_angry_sprite.visible = true
		eyelid_sprite.visible = true
	else:
		interface_face_angry_sprite.visible = false
		eyelid_sprite.visible = false
	
	if health == 0:
		#trigger death screen
		# stop input/movement
		pass

func attack() -> void:
	spawn_punch()
	clicks_per_second += 1
	if hyper_mode_active:
		AudioManager.play_audio("OGA_" + str(randi_range(3,5)), self)
	else:
		AudioManager.play_audio("PUNCH_" + str(randi_range(1,4)), self)
	if hyper_mode_active:
		spawn_punch()
		spawn_punch()
		if max_hyper_mode_extra_timer > 0:
			var time_left = slowmo_timer.time_left
			max_hyper_mode_extra_timer -= 0.01
			slowmo_timer.stop()
			slowmo_timer.start(time_left + 0.01)

func spawn_punch():
	var init_pos = random_point_in_area()
	var attack_instance = ATTACK.instantiate()
	if hyper_mode_active : attack_instance.speed = 30000
	attack_instance.init_pos = init_pos
	attack_instance.parent_context = self
	attck_guide.add_child(attack_instance)

func apply_recoil(cam_kick: float = 0.15) -> void:
	var dir := Vector2.from_angle(get_angle())
	recoil += -dir * RECOIL_STRENGTH
	recoil = recoil.limit_length(RECOIL_MAX)
	camera_2d.shake(cam_kick)
	charge_skill()

func charge_skill():
	if not skill_active and not hyper_mode_active:
		skill_charge = min(skill, skill_charge + skilling)
		skill_bar.health = skill_charge
		if skill_charge == skill:
			skill_active = true

func take_damage(damage:int = 50):
	if invincibility_timer.is_stopped():
		print("damage taken")
		health = max(0, health - damage)
		hp_bar.health = health
		camera_2d.shake(0.25)
		invincibility_timer.start()

func critical_hit(_enemy_pos):
	if skill_active and slowmo_timer.is_stopped() and not hyper_mode_active:
		print("entering slow mo")
		clicks_per_second += 10
		enemy_pos = _enemy_pos
		hyper_mode_active = true
		attack_area_collision_shape_2d.scale = Vector2(2.0, 2.0)
		slowmo_timer.start()
		slowmo_controller.start_slowmo()
		#todo tween var
		tween_zoom(Vector2(1.5, 1.5))

func _on_slowmo_timer_timeout() -> void:
	if skills[selected_skill] == "Joey":
		spawn_joey()
	else:
		end_slowmo()

func spawn_joey():
	if not joey_instance:
		joey_instance = JOEY.instantiate()
	joey_mode = true
	var dir = 1.0 if (enemy_pos.x - global_position.x) > 0 else -1.0
	print(
		"\n dir: ", dir,
		"\n enemy_pos.x: ", enemy_pos.x,
		"\n global_position.x: ", global_position.x,
		"\n (enemy_pos.x - global_position.x): ", global_position.x,
		)
	joey_instance.position = Vector2((800.0 * dir), 0)
	print("joey global position: ", joey_pos)
	add_child(joey_instance)
	joey_pos = joey_instance.global_position
	joey_instance.animate()
	await get_tree().create_timer(0.17).timeout
	end_slowmo()
	joey_mode = false
	await get_tree().create_timer(0.03).timeout
	joey_instance.queue_free()

func end_slowmo():
	print("exiting slowmo")
	tween_zoom(Vector2(1, 1))
	slowmo_controller.stop_slowmo()
	slowmo_timer.wait_time = 1.0
	skill_charge = 0
	skill_bar.health = skill_charge
	skill_active = false
	await get_tree().create_timer(1).timeout
	attack_area_collision_shape_2d.scale = Vector2(1.0, 1.0)
	hyper_mode_active = false
	joey_mode = false

func tween_zoom(zoom_val: Vector2, tween_time: float = 0.5):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera_2d, "zoom", zoom_val, tween_time)

func random_point_in_area() -> Vector2:
	var rect = attack_area_collision_shape_2d.shape
	var e = rect.extents
	var p_local = Vector2(randf_range(-e.x, e.x), randf_range(-e.y, e.y))
	return attack_area_collision_shape_2d.to_global(p_local)

func get_angle(deadzone: float = 0.1):
	var v = Input.get_vector("con_left", "con_right", "con_up", "con_down")
	if Global.controller_active:
		if v.length() > deadzone:
			body_sprite.scale.x = (-1.0 * abs(body_sprite.scale.x)) if v.x < 0.0 else abs(body_sprite.scale.x)
			return v.angle()
	else:
		body_sprite.scale.x = (-1.0 * abs(body_sprite.scale.x)) if get_global_mouse_position().x < global_position.x else abs(body_sprite.scale.x)
		return (get_global_mouse_position() - global_position).angle()
