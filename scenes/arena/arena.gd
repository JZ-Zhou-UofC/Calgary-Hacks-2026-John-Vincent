extends Node2D

#################################################
# CONSTANTS
#################################################

const ARENA_SIZE = Vector2(1200, 800)

#################################################
# NODE REFERENCES
#################################################

@onready var background: TextureRect = $Background
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var boss_spawn: Marker2D = $BossSpawn
@onready var actor_container: Node2D = $ActorContainer
var yeti_scene = preload("res://scenes/actors/Yeti/Yeti.tscn")

@onready var yeti_spawn_timer: Timer = $YetiSpawnTimer
#################################################
# SCENES
#################################################

var player_scene = preload("res://scenes/actors/player/Player.tscn")
var boss_scene = preload("res://scenes/actors/Boss/Boss.tscn")

#################################################
# BACKGROUND TEXTURES
#################################################

var background_textures = {
	"Boss": preload("res://assets/boss_map.png"),
	"Ice": preload("res://assets/ice_map.png")
}

#################################################
# READY
#################################################

func _ready():

	load_background()
	spawn_player()

	if GameState.selected_map == "Boss":
		spawn_boss()
	
	elif GameState.selected_map == "Ice":
		start_yeti_spawning()
	else:
		spawn_normal_enemies()
	

#################################################
# LOAD BACKGROUND
#################################################
func load_background():

	var texture = background_textures.get(GameState.selected_map)

	if texture == null:
		push_error("Background not found")
		return

	background.texture = texture

	# Force exact arena size
	background.size = ARENA_SIZE

	# Center arena at (0,0)
	background.position = Vector2(
		-ARENA_SIZE.x / 2,
		-ARENA_SIZE.y / 2
	)

	# Proper scaling
	background.stretch_mode = TextureRect.STRETCH_SCALE



#################################################
# SPAWN PLAYER
#################################################

func spawn_player():

	if player_spawn == null or actor_container == null:
		push_error("Missing PlayerSpawn or ActorContainer")
		return

	var player = player_scene.instantiate()

	player.global_position = player_spawn.global_position

	actor_container.add_child(player)

#################################################
# SPAWN BOSS
#################################################
const ARENA_HALF_SIZE = Vector2(600, 400)

func spawn_boss():

	var boss = boss_scene.instantiate()

	var corners = [
		Vector2(-ARENA_HALF_SIZE.x, -ARENA_HALF_SIZE.y), # top-left
		Vector2( ARENA_HALF_SIZE.x, -ARENA_HALF_SIZE.y), # top-right
		Vector2(-ARENA_HALF_SIZE.x,  ARENA_HALF_SIZE.y), # bottom-left
		Vector2( ARENA_HALF_SIZE.x,  ARENA_HALF_SIZE.y)  # bottom-right
	]

	var chosen_corner = corners.pick_random()

	boss.global_position = chosen_corner

	actor_container.add_child(boss)

	print("Boss spawned at:", chosen_corner)


#################################################
# SPAWN NORMAL ENEMIES
#################################################

func spawn_normal_enemies():

	print("Spawning normal enemies")
	
func _on_pass_button_pressed():
		handle_stage_end(true)
func _on_fail_button_pressed():
		handle_stage_end(false)
		
func handle_stage_end(passed: bool):
	if passed:
		GameState.gain_energy(4)
	else:
		GameState.gain_energy(3)
		
	GameState.advance_turn()
	SceneManager.goto_hub()


#################################################
# YETI SPAWNING
#################################################
func start_yeti_spawning():

	if yeti_spawn_timer == null:
		push_error("YetiSpawnTimer not found")
		return

	yeti_spawn_timer.timeout.connect(spawn_yeti)

	yeti_spawn_timer.start()

	print("Yeti spawning started")



func spawn_yeti():

	var yeti = yeti_scene.instantiate()

	yeti.global_position = get_random_spawn_position()

	actor_container.add_child(yeti)

	print("Yeti spawned at:", yeti.global_position)

func get_random_spawn_position():

	return Vector2(
		randf_range(-580, 580),
		randf_range(-380, 380)
	)
