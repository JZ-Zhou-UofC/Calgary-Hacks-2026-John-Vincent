extends CharacterBody2D

#################################################
# CONSTANTS
#################################################

const ARENA_HALF_SIZE = Vector2(600, 400)

#################################################
# NODE REFERENCES
#################################################

@onready var sprite: Sprite2D = $Sprite2D
@onready var direction_timer: Timer = $DirectionTimer

#################################################
# MOVEMENT
#################################################

@export var speed: float = 80.0

var direction: Vector2

#################################################
# READY
#################################################

func _ready():

	sprite.texture = preload("res://assets/characters/yeti.png")

	randomize_direction()

	direction_timer.timeout.connect(randomize_direction)

	z_index = 5

#################################################
# MOVEMENT
#################################################

func _physics_process(delta):

	velocity = direction * speed

	move_and_slide()

	check_bounds()

#################################################
# RANDOM MOVEMENT
#################################################

func randomize_direction():

	direction = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized()

#################################################
# KEEP INSIDE ARENA
#################################################

func check_bounds():

	var pos = global_position

	if pos.x < -ARENA_HALF_SIZE.x or pos.x > ARENA_HALF_SIZE.x:
		direction.x *= -1

	if pos.y < -ARENA_HALF_SIZE.y or pos.y > ARENA_HALF_SIZE.y:
		direction.y *= -1
