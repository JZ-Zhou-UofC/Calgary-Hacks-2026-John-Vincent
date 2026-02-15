extends CharacterBody2D
@export var speed := 40.0
@export var damage := 10
@export var damage_cooldown := 1.0  # Thời gian giữa các lần damage

var direction := Vector2.ZERO
var can_damage := true
var damage_timer := 0.0

func _ready():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	$AnimatedSprite2D.play("idle")
	# Đặt collision layer riêng cho enemy
	collision_layer = 2  # Layer 2 cho enemy
	collision_mask = 1   # Chỉ va chạm với player (layer 1)

func _physics_process(delta):
	# Xử lý cooldown damage
	if not can_damage:
		damage_timer += delta
		if damage_timer >= damage_cooldown:
			can_damage = true
			damage_timer = 0.0
	
	velocity = direction * speed
	
	# Sử dụng move_and_collide thay vì move_and_slide
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		
		# Nếu va chạm với player
		if collider.has_method("take_damage") and can_damage:
			collider.take_damage(damage)
			can_damage = false
			damage_timer = 0.0
		
		# Đổi hướng khi va chạm
		direction = direction.bounce(collision.get_normal())
