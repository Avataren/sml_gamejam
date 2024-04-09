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

# Called when the node enters the scene tree for the first time.
func _ready():
	music_player.connect("finished", _on_loop_sound)
	_on_loop_sound()

func _on_loop_sound():
	var oldstream = music_player.stream
	while(oldstream == music_player.stream):
		music_player.stream = music.pick_random()
	music_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
