extends CharacterBody2D
@export var attack_distance := 50.0
@export var speed := 50.0
var last_position: Vector2
var actual_velocity:= 0.0
@export var hp = 2
var alive = true
var spellbook:Spellbook
var aim_point:Vector2
@export var starting_spells:Array[SpellResource]

func _ready():
	#add_to_group("enemies")
	_play_animation_rnd("idle")
	last_position = global_position
	aim_point = $aim_point.global_position
	
	spellbook = Spellbook.new()
	spellbook.spell_collision_layer = 1
	spellbook.spell_collision_mask = 1
	add_child(spellbook)
	for spell in starting_spells:
		spellbook.add_spell(spell)	
	
func _play_animation_rnd(animation_name):
	if ($AnimationPlayer.current_animation == animation_name):
		return
	# Get the length of the animation
	var animation_length = $AnimationPlayer.get_animation(animation_name).get_length()
	# Generate a random starting point
	var random_start = randf() * animation_length
	# Seek to the random start point in the animation
	$AnimationPlayer.play(animation_name)
	$AnimationPlayer.seek(random_start, true)	

func hit(damage):
	if (!alive):
		return
	if ($AnimationPlayer.current_animation != "attack"):
		$AnimationPlayer.play("hit")
	hp -= damage
	if (hp <= 0):
		$CollisionShape2D.disabled = true
		alive = false
		$AnimationPlayer.stop()
		$AnimationPlayer.play("death")
		await $AnimationPlayer.animation_finished
		queue_free()
	
func _melee_attack():
	Global.player.hit(1)
	
func _physics_process(delta):
	if (!alive):
		return;
	aim_point = $aim_point.global_position
	actual_velocity = (global_position - last_position).length() / delta
	last_position = global_position	
	if (Global.player):
		
		var direction = global_position.direction_to(Global.player.global_position)	
		var distance = global_position.distance_to(Global.player.global_position)
		
		velocity = direction * speed
		move_and_slide()
		
		if direction.x > 0:
			%mob_sprite.scale.x = 1  # Assuming your sprite faces right by default
		elif direction.x < 0:
			%mob_sprite.scale.x = -1
		
		if (distance < attack_distance):
			$AnimationPlayer.play("attack")
		elif ($AnimationPlayer.current_animation != "hit" && $AnimationPlayer.current_animation != "death"):
			if (actual_velocity < speed*0.7):
				_play_animation_rnd("idle")
			else:
				_play_animation_rnd("walk")
				
func get_spell_casting_position(spell_name):
	return aim_point
	
func get_spell_casting_direction(spell_name):

	return (Global.player.aim_point - get_spell_casting_position(spell_name)).normalized()
