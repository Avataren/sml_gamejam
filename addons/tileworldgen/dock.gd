@tool
extends Control

# Exported variable
var seed:int = 123
var octaves = 5
var frequency = 0.005
var width := 512
var height := 512

func _ready():
	# Assume there's a SpinBox in the scene with the name "SeedSpinBox"
	var seed_spin_box = %SeedSpinBox
	seed_spin_box.value = seed  # Initialize the SpinBox with the current seed value

	var octaves_spin_box = %OctaveSpinBox
	octaves_spin_box.value = octaves

	var frequency_spin_box = %FrequencySpinBox
	frequency_spin_box.value = frequency

func _on_seed_spin_box_value_changed(value):
	seed = value
	
func _on_octave_spin_box_value_changed(value):
	octaves = value

func _on_frequency_spin_box_value_changed(value):
	frequency = value

func _on_size_spin_box_value_changed(value):
	width = value
	height = value
