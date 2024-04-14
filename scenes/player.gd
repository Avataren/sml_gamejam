extends CharacterBody2D

const SPEED = 100.0
@onready var sprite = %Sprite2D
@onready var spellbook:Spellbook
@export var starting_spells:Array[SpellResource]
var aim_point:Vector2

var max_hp = 10
var hp = max_hp
var alive = true
var first = true

@onready var player_area:Area2D = %PlayerBoundsArea
func _ready():
	Global.player = self

	%ProgressBar.max_value = max_hp
	%ProgressBar.value = max_hp
	
	spellbook = Spellbook.new()
	spellbook.spell_collision_layer = 2
	spellbook.spell_collision_mask = 0b00000000_00000000_00000000_00001000
	add_child(spellbook)
	for spell in starting_spells:
		spellbook.add_spell(spell)
	
	
func hit(damage):
	hp -= damage;
	%ProgressBar.value = hp;
	if (hp <= 0):
		%ProgressBar.value = 0;
		alive = false
		if !$AudioStreamPlayer2D.playing && !Global.game_over:
			$AudioStreamPlayer2D.play()
		
	
func _physics_process(_delta):
	if !alive:
		return;
	if first:
		spellbook.cast_initial_spells()
		first = false
		
	aim_point = $aim_point.global_position
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	move_and_slide()
	# Check for horizontal movement
	if direction.x > 0:
		sprite.scale.x = -1  # Assuming your sprite faces left by default
	elif direction.x < 0:
		sprite.scale.x = 1

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
