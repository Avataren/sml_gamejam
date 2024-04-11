extends Node2D
@export var audio_volume := 0.0
@onready var music_player = %AudioStreamPlayer
@onready var fadeout_timer = %FadeoutTimer
var tween;

var fade_out_duration := 10.0
var song_length := 120.0 

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
	randomize();
	music.shuffle();
	#music_player.connect("finished", _on_loop_sound)
	_on_loop_sound()

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
