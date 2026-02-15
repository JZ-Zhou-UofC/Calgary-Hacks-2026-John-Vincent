extends CharacterBody2D

@export var speed := 300.0

@onready var body = $Body
var portraits = {
	GameState.LifeStage.BABY: preload("res://assets/characters/brotato/baby.png"),
	GameState.LifeStage.TEEN: preload("res://assets/characters/brotato/teen.png"),
	GameState.LifeStage.PRIME: preload("res://assets/characters/brotato/prime.png"),
	GameState.LifeStage.OLD: preload("res://assets/characters/brotato/old.png")
}
func _ready():

	load_from_gamestate()


func load_from_gamestate():

	# load stats
	speed = GameState.player["speed"]

	# load portrait
	var stage = GameState.life_stage

	if portraits.has(stage):
		body.texture = portraits[stage]
func _physics_process(delta):

	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	# movement
	velocity = direction * speed
	move_and_slide()

	# flip body left/right only
	update_facing(direction)


func update_facing(direction):

	if direction.x > 0:
		body.flip_h = false

	elif direction.x < 0:
		body.flip_h = true
