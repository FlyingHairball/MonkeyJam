extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var attck_guide: Sprite2D = $AttckGuide
@onready var attack_area_collision_shape_2d: CollisionShape2D = $AttackArea/CollisionShape2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("con_jump")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if Global.controller_active: direction = Input.get_axis("con_left", "con_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var angle = get_angle()
	if angle != null:
		attck_guide.rotation = angle
	
	if (Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("con_attack")):
		attack()
		

	move_and_slide()

func attack() -> void:
	var init_pos = random_point_in_area()
	



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
