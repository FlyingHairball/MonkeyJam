extends CharacterBody2D


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
@onready var attack_cooldown: Timer = $AttackCooldown

func _process(_delta: float) -> void:
	camera_2d.global_position.y = min(360.0, position.y)

func _physics_process(delta: float) -> void:
	
	if recoil:
		velocity += recoil
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor() and !recoil:
		velocity = Vector2.ZERO
	
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
	Input.is_action_just_pressed("con_attack")) and attack_cooldown.is_stopped():
		attack_cooldown.start()
		attack()
	#if recoil:
		#print(recoil)
	move_and_slide()
	recoil = recoil.move_toward(Vector2.ZERO, RECOIL_DECAY * delta)

func attack() -> void:
	var init_pos = random_point_in_area()
	var attack_instance = ATTACK.instantiate()
	attack_instance.init_pos = init_pos
	attack_instance.parent_context = self
	attck_guide.add_child(attack_instance)

func apply_recoil():
	var aim_dir := Vector2.from_angle(get_angle())
	#print(aim_dir, rotation)
	recoil += (-aim_dir * RECOIL_STRENGTH)
	recoil = recoil.limit_length(RECOIL_MAX)
	camera_2d.shake(0.15)

func take_damage():
	
	#camera_2d.shake(0.15)
	pass

func random_point_in_area() -> Vector2:
	var rect = attack_area_collision_shape_2d.shape
	var e = rect.extents
	var p_local = Vector2(randf_range(-e.x, e.x), randf_range(-e.y, e.y))
	return attack_area_collision_shape_2d.to_global(p_local)

func get_angle(deadzone: float = 0.1):
	var v = Input.get_vector("con_left", "con_right", "con_up", "con_down")
	if Global.controller_active:
		if v.length() > deadzone:
			return v.angle()
	else: 
		return (get_global_mouse_position() - global_position).angle()
