extends Node2D

@onready var music_player = %AudioStreamPlayer

var music= [
	preload("res://music/Neon Sorcery.mp3"),
	preload("res://music/Neon Sorcery2.mp3"),
	preload("res://music/Neon Wizard.mp3"),
	preload("res://music/Neon Wizard2.mp3"),
	preload("res://music/Neon Uprising.mp3"),
	preload("res://music/Neon Uprising2.mp3"),
	preload("res://music/Pixelated Dreams.mp3"),
	preload("res://music/Pixelated Dreams2.mp3"),
]
var current_song:=0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	music.shuffle();
	music_player.connect("finished", _on_loop_sound)
	_on_loop_sound()

func _on_loop_sound():
	music_player.stream = music[current_song]
	current_song = (current_song +1) % music.size()
	music_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
