extends PanelContainer

signal energy_spent


func _on_train_button_pressed():

	GameState.spend_energy_on_training()

	# notify Hub to refresh UI
	energy_spent.emit()
