extends Control

@export var music_player:AudioStreamPlayer
signal go_to_menu

	
func _on_exit_game_button_pressed():
	get_tree().quit()

func _on_exit_to_menu_button_pressed():
	go_to_menu.emit()
		#var tween1=modulator.create_tween()
		#tween1.tween_property(modulator, "color", Color.BLACK,1.0)
		#music.create_tween().tween_property(music, "volume_db", -60, 1.0)
		#tween1.connect("finished",load_level)
	#if (music_player):
		#music_player.stop()
	#var main_menu = load("res://ui/main_menu.tscn")
	#get_tree().root.add_child(main_menu.instantiate())
	#queue_free()		
	
