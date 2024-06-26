extends Node2D

@export var first_level:PackedScene
@onready var music=$AudioStreamPlayer
@onready var modulator=$CanvasLayer/CanvasModulate
# Called when the node enters the scene tree for the first time.

func _ready():
	randomize();
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	#RenderingServer.set_default_clear_color(Color(0,0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_exit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	if (first_level):
		var tween1=get_tree().create_tween()
		var tween2=get_tree().create_tween()
		tween1.tween_property(modulator, "color", Color.BLACK,0.5)
		tween2.tween_property(music, "volume_db", -60, 0.6)
		tween2.connect("finished",load_level)

func load_level():
	#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	get_tree().root.add_child(first_level.instantiate())
	queue_free()

func _on_toggle_fullscreen_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if (mode == DisplayServer.WINDOW_MODE_FULLSCREEN):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
