extends Node

#################################################
# TURN SYSTEM (MOST IMPORTANT)
#################################################

var turn: int = 1
var selected_map: String = "TestMap"

enum LifeStage {
	BABY,
	TEEN,
	PRIME,
	OLD,
	DEAD
}

var life_stage: LifeStage = LifeStage.BABY

#################################################
# CURRENT PLAYER BODY (resets every generation)
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
# META PROGRESSION (persists across generations)
#################################################

var meta = {

	"legacy_augments": [],

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

var energy_essence: int = 0

#################################################
# MAP TRACKING
#################################################

var last_enemy_armor_type: String = "A"

#################################################
# TURN ADVANCEMENT
#################################################

func advance_turn():

	turn += 1

	match life_stage:

		LifeStage.BABY:
			life_stage = LifeStage.TEEN
			apply_teen_bonus()

		LifeStage.TEEN:
			life_stage = LifeStage.PRIME
			apply_prime_bonus()

		LifeStage.PRIME:
			life_stage = LifeStage.OLD
			apply_old_penalty()

		LifeStage.OLD:
			life_stage = LifeStage.DEAD
			handle_death_and_rebirth()

#################################################
# LIFE STAGE EFFECTS
#################################################

func apply_teen_bonus():

	player.damage += 5
	player.speed += 20


func apply_prime_bonus():

	player.damage += 10
	player.speed += 30
	player.max_hp += 20


func apply_old_penalty():

	player.damage -= 5
	player.speed -= 20


#################################################
# DEATH AND REBIRTH
#################################################

func handle_death_and_rebirth():

	create_new_child()

	life_stage = LifeStage.BABY

#################################################
# CHILD CREATION
#################################################

func create_new_child():

	player.max_hp = 100 + meta.child_bonus.max_hp
	player.hp = player.max_hp

	player.damage = 10 + meta.child_bonus.damage
	player.speed = 300 + meta.child_bonus.speed
	player.armor = 0 + meta.child_bonus.armor

	# inherit trained proficiency
	player.weapon_proficiency = meta.weapon_proficiency_bonus.duplicate()

	adapt_weapon_to_enemy()

#################################################
# WEAPON ADAPTATION SYSTEM
#################################################

func adapt_weapon_to_enemy():

	match last_enemy_armor_type:

		"A":
			player.weapon_type = "B"

		"B":
			player.weapon_type = "C"

		"C":
			player.weapon_type = "A"

#################################################
# ENERGY ESSENCE SYSTEM
#################################################

func gain_energy(amount):

	energy_essence += amount


func spend_energy_on_training():

	if energy_essence >= 5:

		energy_essence -= 5

		meta.weapon_proficiency_bonus[player.weapon_type] += 1


func spend_energy_on_child_nurture():

	if energy_essence >= 5:

		energy_essence -= 5

		meta.child_bonus.max_hp += 5
		meta.child_bonus.damage += 1


func spend_energy_on_lifespan():

	if energy_essence >= 5:

		energy_essence -= 5

		if life_stage == LifeStage.OLD:
			life_stage = LifeStage.PRIME


func spend_energy_on_legacy():

	if energy_essence >= 5:

		energy_essence -= 5

		meta.legacy_augments.append("damage_boost")
	
func prepare_for_new_round():

	# Reset temporary round resources
	energy_essence = 0

	print("Preparing new round")
	print("Turn:", turn)
	print("Life stage:", life_stage)
