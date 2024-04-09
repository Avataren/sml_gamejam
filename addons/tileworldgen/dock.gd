@tool
extends Control

# Exported variable
var seed:int = 123

func _ready():
	# Assume there's a SpinBox in the scene with the name "SeedSpinBox"
	var seed_spin_box = $VBoxContainer/SeedSpinBox
	seed_spin_box.value = seed  # Initialize the SpinBox with the current seed value
	print ("setting initial seed to ", seed)

func _on_seed_spin_box_value_changed(value):
	print ("setting seed ", value)
	seed = value
	
