extends CharacterBody2D
@export var speed := 250.0
@export var max_hp := 100
@export var invulnerable_time := 0.5  

var hp := 100
var is_invulnerable := false
var invulnerable_timer := 0.0

@onready var health_bar = $"../CanvasLayer/HealthBar"

func _ready():	
	hp = max_hp
	health_bar = get_tree().get_first_node_in_group("healthbar")
	print("Health bar:", health_bar)
	update_health_ui()
	
	# Đặt collision layer cho player
	collision_layer = 1  
	collision_mask = 1   

func _physics_process(delta):

	if is_invulnerable:
		invulnerable_timer += delta

		$AnimatedSprite2D.modulate.a = 0.5 if int(invulnerable_timer * 10) % 2 else 1.0
		
		if invulnerable_timer >= invulnerable_time:
			is_invulnerable = false
			invulnerable_timer = 0.0
			$AnimatedSprite2D.modulate.a = 1.0
	
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
	

	
	update_animation(direction)

func take_damage(amount):
	if is_invulnerable:
		return
	
	hp -= amount
	is_invulnerable = true
	invulnerable_timer = 0.0
	
	update_health_ui()
	
	# Hiệu ứng knockback nhẹ (tùy chọn)
	# velocity = -velocity.normalized() * 100
	
	if hp <= 0:
		die()

func clamp_position_to_screen():
	# Lấy kích thước viewport
	var viewport_size = get_viewport_rect().size
	var margin = 20  # Khoảng cách từ mép màn hình
	
	position.x = clamp(position.x, margin, viewport_size.x - margin)
	position.y = clamp(position.y, margin, viewport_size.y - margin)

func update_health_ui():
	if health_bar:
		health_bar.value = hp

func die():
	print("Game Over")
	queue_free()

func update_animation(direction):
	if direction == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walk")
		
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif direction.x > 0:
			$AnimatedSprite2D.flip_h = false
