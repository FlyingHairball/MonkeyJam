extends CharacterBody2D

const colliding_obj = true

const SPEED = 2
const mangas = [preload("uid://chpn7smvhkop"), preload("uid://xxys8dp4j82v"), preload("uid://uo00ib1rcuxx")]
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var book_collision: CollisionShape2D = $HitArea/BookCollision
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = mangas[Global.rng.randi_range(0,2)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += SPEED * get_gravity() * delta
	move_and_slide()


func _on_hit_area_body_entered(body: Node2D) -> void:
	collision_shape_2d.set_deferred("disabled", false)
	book_collision.set_deferred("disabled", true)
	if body.has_method("take_damage"):
		body.take_damage()
		body.apply_recoil(0.4)


func _on_timer_timeout() -> void:
	var tween = create_tween()
	var time = 1.0
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color("ffffff00"), time)
	await get_tree().create_timer(time).timeout
	queue_free()
	
