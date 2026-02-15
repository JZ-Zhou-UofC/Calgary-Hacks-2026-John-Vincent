extends CharacterBody2D

#################################################
# MOVEMENT
#################################################

@export var speed := 300.0

@onready var body = $Body


#################################################
# WEAPON
#################################################

@onready var weapon_pivot = $WeaponPivot
@onready var weapon_sprite = $WeaponPivot/WeaponSprite

var weapon_textures = {
	"A": preload("res://assets/weapons/weapon_A.png"),
	"B": preload("res://assets/weapons/weapon_B.png"),
	"C": preload("res://assets/weapons/weapon_C.png")
}


#################################################
# PORTRAITS
#################################################

var portraits = {
	GameState.LifeStage.BABY: preload("res://assets/characters/brotato/baby.png"),
	GameState.LifeStage.TEEN: preload("res://assets/characters/brotato/teen.png"),
	GameState.LifeStage.PRIME: preload("res://assets/characters/brotato/prime.png"),
	GameState.LifeStage.OLD: preload("res://assets/characters/brotato/old.png")
}


#################################################
# SWING SYSTEM (AUTO)
#################################################

var swing_speed = 6.0
var swing_angle = 70.0
var swing_time = 0.0


#################################################
# READY
#################################################

func _ready():

	load_from_gamestate()
	update_weapon()


#################################################
# LOAD PLAYER DATA
#################################################

func load_from_gamestate():

	speed = GameState.player["speed"]

	var stage = GameState.life_stage

	if portraits.has(stage):
		body.texture = portraits[stage]


#################################################
# PHYSICS
#################################################

func _physics_process(delta):

	handle_movement(delta)
	update_weapon_rotation()
	update_auto_swing(delta)


#################################################
# MOVEMENT
#################################################

func handle_movement(delta):

	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed

	move_and_slide()

	update_facing(direction)


func update_facing(direction):

	if direction.x > 0:
		body.flip_h = false

	elif direction.x < 0:
		body.flip_h = true


#################################################
# WEAPON SETUP
#################################################

func update_weapon():

	var weapon_type = GameState.player["weapon_type"]

	if weapon_textures.has(weapon_type):

		weapon_sprite.texture = weapon_textures[weapon_type]


#################################################
# AIM SYSTEM
#################################################

func update_weapon_rotation():

	var mouse_pos = get_global_mouse_position()

	weapon_pivot.look_at(mouse_pos)


#################################################
# AUTO SWING SYSTEM
#################################################

func update_auto_swing(delta):

	swing_time += delta * swing_speed

	var swing_offset = sin(swing_time) * swing_angle

	weapon_sprite.rotation_degrees = swing_offset
