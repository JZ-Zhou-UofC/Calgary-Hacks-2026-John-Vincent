extends CharacterBody2D
@export var speed := 40.0
@export var damage := 10
@export var damage_cooldown := 1.0
@export var tilemap:TileMap

var direction := Vector2.ZERO
var can_damage := true
var damage_timer := 0.0
var check_tile_timer := 0.0
var check_tile_interval := 0.5  # Check every 0.5 seconds

func _ready():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	$AnimatedSprite2D.play("idle")
	
	# Collision setup
	collision_layer = 2
	collision_mask = 1 | 4
	
	# Auto-find TileMap if not assigned
	if not tilemap:
		tilemap = get_tree().get_first_node_in_group("tilemap")
		if not tilemap:
			push_warning("TileMap not found for Yeti despawn check!")

func _physics_process(delta):
	# Damage cooldown
	if not can_damage:
		damage_timer += delta
		if damage_timer >= damage_cooldown:
			can_damage = true
			damage_timer = 0.0
	
	# Check if still on valid tile
	check_tile_timer += delta
	if check_tile_timer >= check_tile_interval:
		check_tile_timer = 0.0
		if not is_on_valid_tile():
			despawn()
			return
	
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		
		# Damage player
		if collider.has_method("take_damage") and can_damage:
			collider.take_damage(damage)
			can_damage = false
			damage_timer = 0.0
		
		# Bounce off obstacles
		direction = direction.bounce(collision.get_normal())

# Check if Yeti is standing on a valid ground tile
func is_on_valid_tile() -> bool:
	if not tilemap:
		return true  # If no tilemap, don't despawn
	
	# Convert world position to tile coordinates
	var tile_pos = tilemap.local_to_map(global_position)
	
	# Check if there's a tile at this position (layer 0 = ground)
	var tile_id = tilemap.get_cell_source_id(0, tile_pos)
	
	# -1 means no tile (empty/melted)
	return tile_id != -1

# Despawn with optional effect
func despawn():
	print("Yeti fell off the map at position: ", global_position)
	
	# Optional: Add particle effect or animation here
	# var particles = preload("res://effects/despawn.tscn").instantiate()
	# get_parent().add_child(particles)
	# particles.global_position = global_position
	
	queue_free()
