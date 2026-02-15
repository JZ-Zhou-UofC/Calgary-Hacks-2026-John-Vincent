extends CharacterBody2D

#################################################
# CONSTANTS
#################################################

const ARENA_HALF_SIZE = Vector2(600, 400)

#################################################
# NODE REFERENCES
#################################################

@onready var sprite: Sprite2D = $Sprite2D

#################################################
# BOSS TEXTURES BY TURN
#################################################

var boss_textures = {
	1: preload("res://assets/characters/young_boss.png"),
	3: preload("res://assets/characters/prime_boss.png"),
	6: preload("res://assets/characters/old_boss.png")
}

#################################################
# MOVEMENT
#################################################

@export var speed: float = 400.0

var direction: Vector2 = Vector2.ZERO

#################################################
# READY
#################################################

func _ready():

	assign_texture()
	randomize_direction()

	# Make sure boss renders above background
	z_index = 10

	print("Boss ready at:", global_position)

#################################################
# ASSIGN TEXTURE BASED ON TURN
#################################################

func assign_texture():

	var current_turn = GameState.turn

	var thresholds = boss_textures.keys()
	thresholds.sort()

	var selected_texture = boss_textures[thresholds[0]]

	for turn_threshold in thresholds:
		if current_turn >= turn_threshold:
			selected_texture = boss_textures[turn_threshold]

	sprite.texture = selected_texture

	print("Boss texture set for turn:", current_turn)

#################################################
# PHYSICS MOVEMENT
#################################################

func _physics_process(delta):

	velocity = direction * speed

	move_and_slide()

	check_bounds()

#################################################
# RANDOMIZE MOVEMENT DIRECTION
#################################################

func randomize_direction():

	direction = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized()

#################################################
# KEEP BOSS INSIDE ARENA
#################################################

func check_bounds():

	var pos = global_position

	var hit_wall = false

	if pos.x < -ARENA_HALF_SIZE.x:
		pos.x = -ARENA_HALF_SIZE.x
		direction.x *= -1
		hit_wall = true

	elif pos.x > ARENA_HALF_SIZE.x:
		pos.x = ARENA_HALF_SIZE.x
		direction.x *= -1
		hit_wall = true

	if pos.y < -ARENA_HALF_SIZE.y:
		pos.y = -ARENA_HALF_SIZE.y
		direction.y *= -1
		hit_wall = true

	elif pos.y > ARENA_HALF_SIZE.y:
		pos.y = ARENA_HALF_SIZE.y
		direction.y *= -1
		hit_wall = true

	global_position = pos

	if hit_wall:
		print("Boss bounced at:", pos)
