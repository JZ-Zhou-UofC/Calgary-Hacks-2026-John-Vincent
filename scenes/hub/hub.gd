extends Control

@onready var stats_panel = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel
@onready var weapon_panel = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel
@onready var option_panel = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel

# example labels inside panels
@onready var turn_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/TurnLabel
@onready var life_stage_label = $MainVBox/CharacterPanel/CharacterHBox/StatsPanel/LifeStageLabel

@onready var weapon_type_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/WeaponTypeLabel
@onready var proficiency_label = $MainVBox/CharacterPanel/CharacterHBox/WeaponPanel/ProficiencyLabel

@onready var energy_label = $MainVBox/CharacterPanel/CharacterHBox/OptionPanel/EnergyLabel


func _ready():

	update_ui()


func update_ui():

	update_stats_panel()
	update_weapon_panel()
	update_option_panel()


func update_stats_panel():

	turn_label.text = "Turn: " + str(GameState.turn)

	life_stage_label.text = "Stage: " + life_stage_to_string(GameState.life_stage)


func update_weapon_panel():

	weapon_type_label.text = "Weapon: " + GameState.player.weapon_type

	var prof = GameState.player.weapon_proficiency[GameState.player.weapon_type]

	proficiency_label.text = "Proficiency: " + str(prof)


func update_option_panel():

	energy_label.text = "Energy: " + str(GameState.energy_essence)


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
	
func _on_start_button_pressed():
	start_round()

	
func start_round():

	# optional: make sure player selected a map
	if GameState.selected_map == null:
		print("No map selected")
		return

	# reset temporary round state if needed
	GameState.prepare_for_new_round()

	# go to arena
	SceneManager.goto_arena()
