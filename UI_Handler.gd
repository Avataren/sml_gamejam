extends Node
@export var ingame_menu:PackedScene
var _instanced_menu
var _menu_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_instanced_menu = ingame_menu.instantiate()
	_instanced_menu.go_to_menu.connect(_go_to_menu)
	
func _go_to_menu():
	%AudioStreamPlayer.stop()
	get_tree().root.remove_child(_instanced_menu)
	var main_menu = load("res://ui/main_menu.tscn")
	get_tree().root.add_child(main_menu.instantiate())
	get_tree().paused = false
	$"..".queue_free()	
		
func _close_ingame_menu():
	print("unpause!")
	get_tree().paused = false
	get_tree().root.remove_child(_instanced_menu)
	_menu_active = false

func _input(event):
	if (Global.game_over):
		return
		
	if (event.is_action_released("escape")):
		if (!_menu_active):
			get_tree().root.add_child(_instanced_menu)
			get_tree().paused = true
			_menu_active = true
		else:
			_close_ingame_menu()
