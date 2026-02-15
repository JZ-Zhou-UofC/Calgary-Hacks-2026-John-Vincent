extends Node2D


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
