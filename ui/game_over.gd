extends Control
signal game_over

func _on_main_menu_button_pressed():
	game_over.emit()
