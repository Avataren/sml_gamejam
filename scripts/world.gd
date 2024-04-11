extends Node2D
@export var audio_volume := 0.0
@export var ingame_menu:PackedScene
@onready var music_player = %AudioStreamPlayer
@onready var fadeout_timer = %FadeoutTimer

var tween;
var _menu_active = false
var fade_out_duration := 10.0
var song_length := 120.0 
var _instanced_menu

var music= [
	preload("res://music/Neon Sorcery.mp3"),
	preload("res://music/Neon Sorcery2.mp3"),
	preload("res://music/Neon Wizard.mp3"),
	preload("res://music/Neon Wizard2.mp3"),
	preload("res://music/Neon Uprising.mp3"),
	preload("res://music/Neon Uprising2.mp3"),
	preload("res://music/Pixelated Dreams.mp3"),
	preload("res://music/Pixelated Dreams2.mp3"),
	preload("res://music/Arcane Odyssey.mp3"),
	preload("res://music/Midnight Spell.mp3"),
	preload("res://music/Midnight Spell2.mp3"),
	preload("res://music/Shadows of the Night.mp3"),
	preload("res://music/Shadows of the Night2.mp3")
]
var current_song:=0

func _ready():
	_instanced_menu = ingame_menu.instantiate()
	_instanced_menu.go_to_menu.connect(_go_to_menu)
	randomize();
	music.shuffle();
	#music_player.connect("finished", _on_loop_sound)
	_on_loop_sound()
	
func _go_to_menu():
	get_tree().root.remove_child(_instanced_menu)
	var main_menu = load("res://ui/main_menu.tscn")
	get_tree().root.add_child(main_menu.instantiate())
	queue_free()	
	
func _on_loop_sound():
	print("Starting next song")
	music_player.stream = music[current_song]
	current_song = (current_song +1) % music.size()
	music_player.volume_db = audio_volume;
	music_player.play()
	fadeout_timer.wait_time = song_length - fade_out_duration
	fadeout_timer.one_shot = true
	fadeout_timer.start()
	
func start_fade_out():
	tween = get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -60, fade_out_duration).set_trans(Tween.EASE_OUT)
	tween.connect("finished",_on_loop_sound)
	
func _on_fadeout_timer_timeout():
	start_fade_out()
	
func _input(event):
	if (event.is_action_released("escape")):
		if (!_menu_active):
			get_tree().root.add_child(_instanced_menu)
			_menu_active = true
		else:
			get_tree().root.remove_child(_instanced_menu)
			_menu_active = false
