@tool
extends EditorPlugin
# A class member to hold the dock during the plugin life cycle.
var dock
var world_gen_script
func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	dock = preload("res://addons/tileworldgen/dock.tscn").instantiate()
	dock.get_node("VBoxContainer/GenWorldButton").connect("pressed", gen_world)
	world_gen_script = preload("res://addons/tileworldgen/procedural_landscape.gd").new()
	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	# Erase the cont

func gen_world():
	print("Gen world!");
	world_gen_script.generate_landscape(dock.seed)
