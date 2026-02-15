extends Control


#################################################
# TEXTURES
#################################################

var portraits = {
	GameState.LifeStage.BABY: preload("res://assets/characters/brotato/baby.png"),
	GameState.LifeStage.TEEN: preload("res://assets/characters/brotato/teen.png"),
	GameState.LifeStage.PRIME: preload("res://assets/characters/brotato/prime.png"),
	GameState.LifeStage.OLD: preload("res://assets/characters/brotato/old.png")
}

var weapon_textures = {
	"A": preload("res://assets/weapons/weapon_A.png"),
	"B": preload("res://assets/weapons/weapon_B.png"),
	"C": preload("res://assets/weapons/weapon_C.png")
}


#################################################
# NODE REFERENCES
#################################################

@onready var portrait_texture = $MainVBox/CharacterPanel/CharacterHBox/PortraitPanel/PortraitTexture
@onready var weapon_image = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/WeaponImage

# Stats
@onready var turn_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/TurnLabel
@onready var life_stage_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/LifeStageLabel
@onready var hp_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/HPLabel
@onready var damage_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/DamageLabel
@onready var speed_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/SpeedLabel
@onready var armor_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/ArmorLabel

# Weapon
@onready var weapon_type_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/WeaponTypeLabel
@onready var proficiency_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/ProficiencyLabel

# Legacy Grid
@onready var legacy_hp_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacyHPLabel
@onready var legacy_damage_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacyDamageLabel
@onready var legacy_speed_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacySpeedLabel
@onready var legacy_armor_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacyArmorLabel

# Options
@onready var energy_label = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/VBoxContainer/EnergyLabel

@onready var train_button = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/VBoxContainer/TrainButton
@onready var legacy_button = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/VBoxContainer/LegacyButton
@onready var lifespan_button = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/VBoxContainer/LifespanButton
@onready var nurture_button = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/VBoxContainer/NurtureButton
@onready var master_weapon_button = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/VBoxContainer/MasterWeaponButton
@onready var hit_gym_button = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/VBoxContainer/HitGymButton


#################################################
# INITIALIZATION
#################################################

func _ready():

	update_ui()


#################################################
# MAIN UI UPDATE
#################################################

func update_ui():

	update_stats_panel()
	update_weapon_panel()
	update_option_panel()
	update_portrait()
	update_legacy_grid()


#################################################
# STATS PANEL
#################################################

func update_stats_panel():

	var player = GameState.player

	turn_label.text = "Turn: " + str(GameState.turn)

	life_stage_label.text = "Stage: " + life_stage_to_string(GameState.life_stage)

	hp_label.text = "HP: " + str(player["hp"]) + " / " + str(player["max_hp"])

	damage_label.text = "Damage: " + str(player["damage"])

	speed_label.text = "Speed: " + str(player["speed"])

	armor_label.text = "Armor: " + str(player["armor"])


#################################################
# WEAPON PANEL
#################################################

func update_weapon_panel():

	var weapon_type = GameState.player["weapon_type"]

	weapon_type_label.text = "Weapon: " + weapon_type

	var prof = GameState.player["weapon_proficiency"][weapon_type]

	proficiency_label.text = "Proficiency: " + str(prof)

	if weapon_textures.has(weapon_type):

		weapon_image.texture = weapon_textures[weapon_type]


#################################################
# OPTION PANEL
#################################################

func update_option_panel():

	var energy = GameState.energy_essence

	energy_label.text = "Energy: " + str(energy)

	var has_energy = energy > 0

	train_button.disabled = not has_energy
	legacy_button.disabled = not has_energy
	lifespan_button.disabled = not has_energy
	nurture_button.disabled = not has_energy
	master_weapon_button.disabled = not has_energy
	hit_gym_button.disabled = not has_energy


#################################################
# LEGACY GRID
#################################################

func update_legacy_grid():

	var legacy = GameState.meta["legacy_augments"]

	update_legacy_label(legacy_hp_label, "HP", legacy["max_hp"])
	update_legacy_label(legacy_damage_label, "DMG", legacy["damage"])
	update_legacy_label(legacy_speed_label, "SPD", legacy["speed"])
	update_legacy_label(legacy_armor_label, "ARM", legacy["armor"])


func update_legacy_label(label: Label, stat: String, value: int):

	label.text = stat + " +" + str(value)

	label.visible = true

	if value > 0:
		label.modulate = Color.WHITE
	else:
		label.modulate = Color(0.5,0.5,0.5)


#################################################
# PORTRAIT
#################################################

func update_portrait():

	var stage = GameState.life_stage

	if portraits.has(stage):

		portrait_texture.texture = portraits[stage]


#################################################
# BUTTON HANDLERS
#################################################

func _on_train_button_pressed():

	if GameState.spend_energy_on_training():

		update_ui()


func _on_hit_gym_button_pressed():

	print("Gym button pressed")

	if GameState.spend_energy_on_hit_the_gym():

		update_ui()


func _on_master_weapon_button_pressed():

	if GameState.spend_energy_on_master_weapon():

		update_ui()


func _on_legacy_button_pressed():

	if GameState.spend_energy_on_legacy():

		update_ui()


func _on_lifespan_button_pressed():

	if GameState.spend_energy_on_lifespan():

		update_ui()


func _on_nurture_button_pressed():

	if GameState.spend_energy_on_child_nurture():

		update_ui()


#################################################
# START ROUND
#################################################

func _on_start_button_pressed():

	GameState.prepare_for_new_round()

	SceneManager.goto_arena()


#################################################
# HELPER
#################################################

func life_stage_to_string(stage):

	match stage:

		GameState.LifeStage.BABY:
			return "Baby"

		GameState.LifeStage.TEEN:
			return "Teen"

		GameState.LifeStage.PRIME:
			return "Prime"

		GameState.LifeStage.OLD:
			return "Old"

	return "Unknown"


func _on_build_muscle_button_pressed() -> void:
	pass # Replace with function body.
