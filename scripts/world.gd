extends Node2D
@export var audio_volume := 0.0

@onready var music_player = %AudioStreamPlayer
@onready var fadeout_timer = %FadeoutTimer
@export var game_over_scene: PackedScene

var tween;
var fade_out_duration := 10.0
var song_length := 120.0 
var end_screen

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

var game_over_music = preload("res://music/you died.mp3")
var current_song:=0
@export var darkness:Color = Color.WHITE
func _ready():
	Global.game_over = false
	$CanvasModulate.color = darkness;
	%WorldEnvironment.environment.tonemap_exposure=0.0;
	get_tree().create_tween().tween_property(%WorldEnvironment.environment,"tonemap_exposure",0.5, 2.0).set_ease(Tween.EASE_OUT)
	music.shuffle();
	#music_player.connect("finished", _on_loop_sound)
	get_tree().paused = false
	_on_loop_sound()
	
func _on_loop_sound():
	music_player.stream = music[current_song]
	current_song = (current_song +1) % music.size()
	#print("Starting next song:", music[current_song])
	music_player.volume_db = audio_volume;
	music_player.play()
	fadeout_timer.wait_time = song_length - fade_out_duration
	fadeout_timer.one_shot = true
	fadeout_timer.start()
	
func start_fade_out():
	tween = get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -60, fade_out_duration).set_trans(Tween.EASE_OUT)
	tween.connect("finished",_on_loop_sound)
	
func _process(_delta):
	if (!Global.game_over):
		if (Global.player.hp <= 0):
			print ("GAME_OVER")
			Global.game_over=true
			get_tree().create_tween().tween_property(%WorldEnvironment.environment,"tonemap_exposure",0.0, 2.0)
			get_tree().create_tween().tween_property(music_player, "volume_db", -60, 0.5)
			await get_tree().create_timer(0.6).timeout
			print ("starting game over music")
			music_player.stream = game_over_music
			music_player.volume_db = audio_volume
			music_player.play()
			await get_tree().create_timer(1.4).timeout
			end_screen = game_over_scene.instantiate()
			end_screen.connect("game_over", end_game)
			get_tree().root.add_child(end_screen)
	
func end_game():
	%AudioStreamPlayer.stop()
	end_screen.queue_free()
	queue_free()
	var main_menu = load("res://ui/main_menu.tscn")
	get_tree().root.add_child(main_menu.instantiate())	
	
func _on_fadeout_timer_timeout():
	start_fade_out()

func _on_area_2d_area_entered_kill(area):
	if (area.is_in_group("spell")):
		area.queue_free()	
