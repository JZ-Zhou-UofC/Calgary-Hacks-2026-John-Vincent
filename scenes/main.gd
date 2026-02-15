extends Control


var current_scene = null

func _ready():
	load_hub()

func load_hub():
	switch_scene("res://scenes/hub/hub.tscn")

func load_arena():
	switch_scene("res://scenes/arena/arena.tscn")

func switch_scene(scene_path):
	if current_scene != null:
		current_scene.queue_free()

	var new_scene = load(scene_path).instantiate()
	add_child(new_scene)
	current_scene = new_scene
