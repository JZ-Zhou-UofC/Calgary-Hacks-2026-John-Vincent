extends Node

var current_scene: Node = null


func _ready():
	current_scene = get_tree().current_scene


func goto_scene(scene_path: String):

	print("Attempting to load scene:", scene_path)

	call_deferred("_deferred_goto_scene", scene_path)


func _deferred_goto_scene(scene_path: String):

	var packed_scene = load(scene_path)

	if packed_scene == null:
		print("ERROR: Scene failed to load:", scene_path)
		return

	if current_scene:
		current_scene.queue_free()

	var new_scene = packed_scene.instantiate()

	get_tree().root.add_child(new_scene)

	get_tree().current_scene = new_scene

	current_scene = new_scene


func goto_hub():

	goto_scene("res://scenes/hub/Hub.tscn")


func goto_arena():

	goto_scene("res://scenes/arena/Arena.tscn")
