extends Control

func _ready():
	print("Current turn:", GameState.turn)


func _on_start_button_pressed():
	load_arena()


func load_arena():
	get_tree().change_scene_to_file("res://scenes/arena/Arena.tscn")
