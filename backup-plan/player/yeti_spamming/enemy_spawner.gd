extends Node2D
@export var enemy_scene: PackedScene
@export var spawn_interval := 2.0
@export var min_spawn_interval := 0.3
@export var difficulty_increase_time := 15.0

var timer := 0.0
var difficulty_timer := 0.0
var viewport_size: Vector2

func _ready():
	viewport_size = get_viewport_rect().size

func _process(delta):
	timer += delta
	difficulty_timer += delta
	
	if timer >= spawn_interval:
		spawn_enemy()
		timer = 0.0
	
	# Tăng độ khó dần dần
	if difficulty_timer >= difficulty_increase_time:
		spawn_interval = max(min_spawn_interval, spawn_interval - 0.15)
		difficulty_timer = 0.0

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	# Spawn từ mép màn hình thay vì random trong màn hình
	var spawn_side = randi() % 4  # 0: top, 1: right, 2: bottom, 3: left
	var spawn_pos = Vector2.ZERO
	
	match spawn_side:
		0:  # Top
			spawn_pos = Vector2(randf_range(0, viewport_size.x), -20)
		1:  # Right
			spawn_pos = Vector2(viewport_size.x + 20, randf_range(0, viewport_size.y))
		2:  # Bottom
			spawn_pos = Vector2(randf_range(0, viewport_size.x), viewport_size.y + 20)
		3:  # Left
			spawn_pos = Vector2(-20, randf_range(0, viewport_size.y))
	
	enemy.global_position = spawn_pos
	get_parent().add_child(enemy)
