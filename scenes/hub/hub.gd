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
# BOSS MAP TEXTURES
#################################################

var boss_map_textures = {
	1: preload("res://assets/characters/young_boss.png"),
	3: preload("res://assets/characters/prime_boss.png"),
	6: preload("res://assets/characters/old_boss.png"),
}

#################################################
# NODE REFERENCES
#################################################

# Boss map button (TextureButton)
@onready var boss_map_button = $MainVBox/MapPanel/MapVBox/MapColumns/BossColumn/BossMapButton

# Normal map buttons
@onready var map_button_1 = $MainVBox/MapPanel/MapVBox/MapColumns/CenterContainer/NormalMapsColumn/MapButton1
@onready var map_button_2 = $MainVBox/MapPanel/MapVBox/MapColumns/CenterContainer/NormalMapsColumn/MapButton2

# Start button
@onready var start_button = $MainVBox/MapPanel/MapVBox/MapColumns/StartButton/StartButton

# Character portrait
@onready var portrait_texture = $MainVBox/CharacterPanel/CharacterHBox/PortraitPanel/PortraitTexture

# Weapon image
@onready var weapon_image = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/WeaponImage

# Stats labels
@onready var turn_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/TurnLabel
@onready var life_stage_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/LifeStageLabel
@onready var hp_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/HPLabel
@onready var damage_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/DamageLabel
@onready var speed_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/SpeedLabel
@onready var armor_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/VBoxContainer/ArmorLabel

# Weapon labels
@onready var weapon_type_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/WeaponTypeLabel
@onready var proficiency_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/ProficiencyLabel

# Legacy labels
@onready var legacy_hp_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacyHPLabel
@onready var legacy_damage_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacyDamageLabel
@onready var legacy_speed_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacySpeedLabel
@onready var legacy_armor_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/VBoxContainer/GridContainer/LegacyArmorLabel

# Energy + option buttons
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

	setup_map_panel()
	update_ui()
	update_map_selection_visual()
	update_start_button()

#################################################
# MAIN UI UPDATE
#################################################

func update_ui():

	update_stats_panel()
	update_weapon_panel()
	update_option_panel()
	update_portrait()
	update_legacy_grid()
	update_boss_map_texture()

#################################################
# MAP PANEL SETUP
#################################################

func setup_map_panel():

	map_button_1.text = "Ice"
	map_button_2.text = "Volcano"

#################################################
# BOSS MAP TEXTURE UPDATE
#################################################

func update_boss_map_texture():

	var current_turn = GameState.turn

	var thresholds = boss_map_textures.keys()
	thresholds.sort()

	var selected_texture = boss_map_textures[thresholds[0]]

	for turn_threshold in thresholds:
		if current_turn >= turn_threshold:
			selected_texture = boss_map_textures[turn_threshold]

	boss_map_button.texture_normal = selected_texture

#################################################
# MAP SELECTION
#################################################

func _on_map_button_1_pressed():

	GameState.selected_map = "Ice"
	update_map_selection_visual()
	update_start_button()

func _on_map_button_2_pressed():

	GameState.selected_map = "Volcano"
	update_map_selection_visual()
	update_start_button()

func _on_boss_map_button_pressed():

	GameState.selected_map = "Boss"
	update_map_selection_visual()
	update_start_button()

#################################################
# MAP VISUAL UPDATE
#################################################

func update_map_selection_visual():

	map_button_1.modulate = Color.WHITE
	map_button_2.modulate = Color.WHITE
	boss_map_button.modulate = Color.WHITE

	match GameState.selected_map:

		"Ice":
			map_button_1.modulate = Color(0.4, 1, 0.4)

		"Volcano":
			map_button_2.modulate = Color(0.4, 1, 0.4)

		"Boss":
			boss_map_button.modulate = Color(1, 0.4, 0.4)

#################################################
# START BUTTON UPDATE
#################################################

func update_start_button():

	start_button.disabled = GameState.selected_map == ""

#################################################
# START ROUND
#################################################

func _on_start_button_pressed():

	if GameState.selected_map == "":
		return

	GameState.prepare_for_new_round()
	SceneManager.goto_arena()

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
# HELPER
#################################################

func life_stage_to_string(stage):

	match stage:

		GameState.LifeStage.BABY: return "Baby"
		GameState.LifeStage.TEEN: return "Teen"
		GameState.LifeStage.PRIME: return "Prime"
		GameState.LifeStage.OLD: return "Old"

	return "Unknown"
