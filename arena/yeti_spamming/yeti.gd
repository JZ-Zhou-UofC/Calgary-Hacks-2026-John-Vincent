extends CharacterBody2D

@export var speed := 40.0
@export var damage := 10
@export var damage_cooldown := 1.0

var direction := Vector2.ZERO
var can_damage := true
var damage_timer := 0.0
var check_timer := 0.0  # Timer to check if still on valid tile

func _ready():
	# Set random movement direction
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	$AnimatedSprite2D.play("idle")
	
	# Set collision layers
	collision_layer = 2  # Enemy is on layer 2
	collision_mask = 1 | 4  # Collide with player (layer 1) and tilemap (layer 4)

func _physics_process(delta):
	# Handle damage cooldown
	if not can_damage:
		damage_timer += delta
		if damage_timer >= damage_cooldown:
			can_damage = true
			damage_timer = 0.0
	
	# Check if still on valid tile every 0.5 seconds
	check_timer += delta
	if check_timer >= 0.5:
		check_timer = 0.0
		if not is_on_ground():
			queue_free()  # Despawn if not on ground
			return
	
	# Move enemy
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	# Handle collisions
	if collision:
		var collider = collision.get_collider()
		
		# Damage player if we hit them
		if collider.has_method("take_damage") and can_damage:
			collider.take_damage(damage)
			can_damage = false
			damage_timer = 0.0
		
		# Bounce off walls and player
		direction = direction.bounce(collision.get_normal())

# Check if enemy is standing on a valid ground tile
func is_on_ground() -> bool:
	# Find the tilemap in the scene
	var tilemap = get_tree().get_first_node_in_group("tilemap")
	if not tilemap:
		return true  # If no tilemap found, don't despawn
	
	# Convert world position to tile coordinates
	var tile_pos = tilemap.local_to_map(global_position)
	
	# Check if there's a tile at this position
	var tile_id = tilemap.get_cell_source_id(0, tile_pos)
	
	# -1 means no tile exists (empty/melted)
	return tile_id != -1
