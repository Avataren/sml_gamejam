extends CharacterBody2D

const SPEED = 100.0
@onready var sprite = %Sprite2D
@onready var spellbook:Spellbook
@export var starting_spells:Array[SpellResource]

var missile:PackedScene = load("res://spells/missile.tscn")
var missile_timer := Timer.new()
var max_hp = 10
var hp = max_hp
var alive = true

@onready var player_area:Area2D = %PlayerBoundsArea
func _ready():
	Global.player = self
	#add_child(missile_timer)
	#missile_timer.wait_time = 0.5
	#missile_timer.one_shot = false
	#missile_timer.start()
	#missile_timer.timeout.connect(_shoot_missile)
	%ProgressBar.max_value = max_hp
	%ProgressBar.value = max_hp
	
	spellbook = Spellbook.new()
	#spellbook.owner = self
	add_child(spellbook)
	for spell in starting_spells:
		spellbook.add_spell(spell)
	
	
func hit(damage):
	hp -= damage;
	%ProgressBar.value = hp;
	#print ("Hit, hp:", hp)
	if (hp <= 0):
		%ProgressBar.value = 0;
		#print ("dead!")
		alive = false
		missile_timer.stop()
#		queue_free()
	
func _shoot_missile():
	var enemies = player_area.get_overlapping_bodies()
	var closest_enemy;
	var closest = INF
	var staff_pos = %StaffPosition.global_position
	for enemy in enemies:
		var enemy_dist = staff_pos.distance_to(enemy.global_position)
		if (enemy_dist < closest):
			closest = enemy_dist
			closest_enemy = enemy
	
	
	var m:Area2D = missile.instantiate()
	m.position = %StaffPosition.global_position
	
	if (closest_enemy):
		m.direction = (closest_enemy.global_position - staff_pos).normalized()
	else:
		m.direction = Vector2(randf_range(-1., 1,), randf_range(-1., 1.)).normalized()
		
	get_parent().add_child(m)
	
func _physics_process(delta):
	if (!alive):
		return;
		
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	move_and_slide()
	# Check for horizontal movement
	if direction.x > 0:
		sprite.scale.x = -1  # Assuming your sprite faces left by default
	elif direction.x < 0:
		sprite.scale.x = 1

func _process(delta):
	pass

func _on_area_2d_area_exited(area):
	if (area.is_in_group("spell")):
		area.queue_free()
		
func get_spell_casting_position(spell_name):
	return %StaffPosition.global_position
	
func get_spell_casting_direction(spell_name):
	var enemies = player_area.get_overlapping_bodies()
	var closest_enemy;
	var closest = INF
	var staff_pos = get_spell_casting_position(spell_name)
	for enemy in enemies:
		var enemy_dist = staff_pos.distance_to(enemy.global_position)
		if (enemy_dist < closest):
			closest = enemy_dist
			closest_enemy = enemy
				
	if (closest_enemy):
		return (closest_enemy.global_position - staff_pos).normalized()
	else:
		return Vector2(randf_range(-1., 1,), randf_range(-1., 1.)).normalized()				
