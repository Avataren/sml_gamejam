extends CharacterBody2D

const SPEED = 100.0
@onready var sprite = %Sprite2D
@onready var spellbook:Spellbook
@export var starting_spells:Array[SpellResource]
var current_wave:Node2D
@export var all_waves:Array[PackedScene]
@export var current_wave_index:int = 0

@export var take_dmg_effect:PackedScene

var aim_point:Vector2

var max_hp = 10
var hp = max_hp
var alive = true

var wave_timer:Timer = Timer.new()

@onready var player_area:Area2D = %PlayerBoundsArea
func _ready():
	Global.player = self
	add_to_group("player")
	%ProgressBar.max_value = max_hp
	%ProgressBar.value = max_hp
	$AnimationPlayer.play("idle")
	spellbook = Spellbook.new()
	spellbook.spell_collision_layer = 2
	spellbook.spell_collision_mask = 0b00000000_00000000_00000000_00001000
	add_child(spellbook)
	print ("starting spells count:", len(starting_spells))
	for spell in starting_spells:
		print ("adding ", spell.name, " to spellbook")
		spellbook.add_spell(spell)
		
	wave_timer.one_shot = true
	add_child(wave_timer)
	_next_wave()

func _free_current_wave():
	for child in get_children():
		if child is BaseWave:
			child.queue_free()
		
func _next_wave():
	print ("next_wave ", current_wave_index, " out of ", len(all_waves))
	if len(all_waves) > current_wave_index:
		
		_free_current_wave()
		current_wave = all_waves[current_wave_index].instantiate()
		add_child(current_wave)
		current_wave_index+=1
		
		wave_timer.set_wait_time(current_wave.wave_duration)
		wave_timer.timeout.connect(_next_wave)
		wave_timer.start()		
	else:
		current_wave_index = 0
		if (all_waves.size() > 0):
			_next_wave()
	
	
func hit(damage):
	if take_dmg_effect:
		var effect = take_dmg_effect.instantiate()
		effect.global_position = $aim_point.global_position
		get_parent().add_child(effect)
		
	hp -= damage;
	%ProgressBar.value = hp;
	if (hp <= 0):
		%ProgressBar.value = 0;
		alive = false
		$AnimationPlayer.play("death")
		if !$AudioStreamPlayer2D.playing && !Global.game_over:
			$AudioStreamPlayer2D.play()
		
	
func _physics_process(_delta):
	if !alive:
		return;
		
	aim_point = $aim_point.global_position
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	if (direction.length() > 0):
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	move_and_slide()
	# Check for horizontal movement
	if direction.x > 0:
		sprite.scale.x = 1
	elif direction.x < 0:
		sprite.scale.x = -1

func _process(_delta):
	pass

func _on_area_2d_area_exited(area):
	if (area.is_in_group("spell")):
		area.queue_free()
		
func can_cast_spell(_spell_name):
	return true
	
func get_spell_casting_position(_spell_name):
	return %StaffPosition.global_position
	
func get_spell_casting_direction(spell_name):
	var enemies = player_area.get_overlapping_bodies()
	var closest_enemy;
	var closest = INF
	var staff_pos = get_spell_casting_position(spell_name)
	for enemy in enemies:
		if !enemy.is_in_group("enemy"):
			continue
		var enemy_dist = staff_pos.distance_to(enemy.aim_point)
		if (enemy_dist < closest):
			closest = enemy_dist
			closest_enemy = enemy
				
	if (closest_enemy):
		return (closest_enemy.aim_point - staff_pos).normalized()
	else:
		return Vector2(randf_range(-1., 1,), randf_range(-1., 1.)).normalized()				
