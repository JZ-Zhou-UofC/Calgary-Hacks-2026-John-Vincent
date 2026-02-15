extends Node

#################################################
# TURN SYSTEM
#################################################

var turn: int = 1
var selected_map: String = "TestMap"

enum LifeStage {
	BABY,
	TEEN,
	PRIME,
	OLD
}

var life_stage: LifeStage = LifeStage.BABY


#################################################
# BASE STATS (DO NOT MODIFY)
#################################################

var BASE_STATS = {
	"max_hp": 100,
	"damage": 10,
	"speed": 300,
	"armor": 0
}


#################################################
# LIFE STAGE MODIFIERS
#################################################

var LIFE_STAGE_MODIFIERS = {

	LifeStage.BABY: {
		"max_hp": -30,
		"damage": -5,
		"speed": -50,
		"armor": -2
	},

	LifeStage.TEEN: {
		"max_hp": 0,
		"damage": 0,
		"speed": 0,
		"armor": 0
	},

	LifeStage.PRIME: {
		"max_hp": 30,
		"damage": 10,
		"speed": 40,
		"armor": 5
	},

	LifeStage.OLD: {
		"max_hp": -10,
		"damage": -5,
		"speed": -60,
		"armor": -3
	}
}


#################################################
# CURRENT PLAYER (RESETS EACH GENERATION)
#################################################

var player = {

	"max_hp": 100,
	"hp": 100,
	"damage": 10,
	"speed": 300,
	"armor": 0,

	"weapon_type": "A",

	"weapon_proficiency": {
		"A": 0,
		"B": 0,
		"C": 0
	}
}


#################################################
# TEMPORARY BONUSES (RESET ON DEATH)
#################################################

var temp_bonus = {
	"max_hp": 0,
	"damage": 0,
	"speed": 0,
	"armor": 0
}


#################################################
# META PROGRESSION (PERSISTS FOREVER)
#################################################

var meta = {

	"legacy_augments": {
		"max_hp": 0,
		"damage": 0,
		"speed": 0,
		"armor": 0
	},

	"weapon_proficiency_bonus": {
		"A": 0,
		"B": 0,
		"C": 0
	},

	"child_bonus": {
		"max_hp": 0,
		"damage": 0,
		"speed": 0,
		"armor": 0
	}
}


#################################################
# RUN RESOURCES
#################################################

var energy_essence: int = 3


#################################################
# MAP TRACKING
#################################################

var last_enemy_armor_type: String = "A"


#################################################
# INITIALIZATION
#################################################

func _ready():

	apply_all_stat_modifiers()


#################################################
# TURN ADVANCEMENT
#################################################

func advance_turn():

	turn += 1

	match life_stage:

		LifeStage.BABY:
			life_stage = LifeStage.TEEN

		LifeStage.TEEN:
			life_stage = LifeStage.PRIME

		LifeStage.PRIME:
			life_stage = LifeStage.OLD

		LifeStage.OLD:
			handle_death_and_rebirth()
			return

	apply_all_stat_modifiers()

	print("Turn:", turn)
	print("Life stage:", life_stage)
	print("Stats:", player)


#################################################
# STAT CALCULATION
#################################################

func apply_all_stat_modifiers():

	var stage_mod = LIFE_STAGE_MODIFIERS[life_stage]
	var child_bonus = meta["child_bonus"]
	var legacy = meta["legacy_augments"]

	player["max_hp"] = BASE_STATS["max_hp"] \
		+ stage_mod["max_hp"] \
		+ child_bonus["max_hp"] \
		+ legacy["max_hp"] \
		+ temp_bonus["max_hp"]

	player["damage"] = BASE_STATS["damage"] \
		+ stage_mod["damage"] \
		+ child_bonus["damage"] \
		+ legacy["damage"] \
		+ temp_bonus["damage"]

	player["speed"] = BASE_STATS["speed"] \
		+ stage_mod["speed"] \
		+ child_bonus["speed"] \
		+ legacy["speed"] \
		+ temp_bonus["speed"]

	player["armor"] = BASE_STATS["armor"] \
		+ stage_mod["armor"] \
		+ child_bonus["armor"] \
		+ legacy["armor"] \
		+ temp_bonus["armor"]

	player["hp"] = player["max_hp"]


#################################################
# DEATH AND REBIRTH
#################################################

func handle_death_and_rebirth():

	print("Death → new child born")

	create_new_child()

	life_stage = LifeStage.BABY

	apply_all_stat_modifiers()


#################################################
# CREATE NEW CHILD
#################################################

func create_new_child():

	# reset temp bonuses
	temp_bonus = {
		"max_hp": 0,
		"damage": 0,
		"speed": 0,
		"armor": 0
	}

	# inherit weapon proficiency
	player["weapon_proficiency"] = meta["weapon_proficiency_bonus"].duplicate()

	adapt_weapon_to_enemy()


#################################################
# WEAPON ADAPTATION
#################################################

func adapt_weapon_to_enemy():

	match last_enemy_armor_type:

		"A":
			player["weapon_type"] = "B"

		"B":
			player["weapon_type"] = "C"

		"C":
			player["weapon_type"] = "A"


#################################################
# ENERGY SYSTEM
#################################################

func gain_energy(amount):

	energy_essence += amount

	print("Energy gained:", amount)


#################################################
# HIT THE GYM (TEMPORARY BONUS)
#################################################

func spend_energy_on_hit_the_gym():

	if energy_essence < 1:
		return false

	energy_essence -= 1

	temp_bonus["damage"] += 3
	temp_bonus["max_hp"] += 15
	temp_bonus["speed"] += 5

	apply_all_stat_modifiers()

	print("Hit Gym applied")

	return true


#################################################
# TRAIN BODY (TEMPORARY BONUS)
#################################################

func spend_energy_on_training():

	if energy_essence < 1:
		return false

	energy_essence -= 1

	temp_bonus["damage"] += 2
	temp_bonus["speed"] += 5
	temp_bonus["max_hp"] += 10

	apply_all_stat_modifiers()

	print("Training applied")

	return true


#################################################
# MASTER WEAPON (PERMANENT + IMMEDIATE)
#################################################

func spend_energy_on_master_weapon():

	if energy_essence < 1:
		return false

	energy_essence -= 1

	var weapon = player["weapon_type"]

	meta["weapon_proficiency_bonus"][weapon] += 1

	player["weapon_proficiency"][weapon] += 1

	print("Weapon mastery increased")

	return true


#################################################
# LEGACY AUGMENT (PERMANENT + IMMEDIATE)
#################################################

func spend_energy_on_legacy():

	if energy_essence < 1:
		print("Not enough energy")
		return false

	energy_essence -= 1

	var stats = ["max_hp", "damage", "speed", "armor"]
	var stat = stats.pick_random()

	match stat:

		"max_hp":
			meta["legacy_augments"]["max_hp"] += 20

		"damage":
			meta["legacy_augments"]["damage"] += 2

		"speed":
			meta["legacy_augments"]["speed"] += 10

		"armor":
			meta["legacy_augments"]["armor"] += 1

	# CRITICAL: Recalculate stats immediately
	apply_all_stat_modifiers()

	print("Legacy upgraded:", stat)
	print("Energy now:", energy_essence)
	print("New stats:", player)

	return true



#################################################
# CHILD NURTURE (PERMANENT FUTURE BONUS)
#################################################

func spend_energy_on_child_nurture():

	if energy_essence < 1:
		return false

	energy_essence -= 1

	meta["child_bonus"]["max_hp"] += 5
	meta["child_bonus"]["damage"] += 1

	print("Child nurture upgraded")

	return true


#################################################
# EXTEND LIFESPAN
#################################################

func spend_energy_on_lifespan():

	if energy_essence < 1:
		return false

	energy_essence -= 1

	if life_stage == LifeStage.OLD:

		life_stage = LifeStage.PRIME

	apply_all_stat_modifiers()

	print("Lifespan extended")

	return true


#################################################
# PREPARE ROUND
#################################################

func prepare_for_new_round():

	energy_essence = 0

	print("Round prepared")
