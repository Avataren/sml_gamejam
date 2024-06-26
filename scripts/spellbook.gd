# Spellbook.gd
extends Node
class_name Spellbook

var spells = {}  # Dictionary to hold SpellResources by name
var timers = {}  # Dictionary to hold timers for each spell

var spell_collision_layer = 1
var spell_collision_mask = 1

func add_spell(spell_resource: SpellResource):
	spells[spell_resource.name] = spell_resource.duplicate()
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(spell_resource.cooldown)
	timer.set_one_shot(false)
	timer.start()
	var callable = Callable(self, "_on_spell_timer_timeout").bind(spell_resource.name)
	timer.timeout.connect.call_deferred(callable)
	timers[spell_resource.name] = timer
	call_deferred("_on_spell_timer_timeout",spell_resource.name)
	#_on_spell_timer_timeout(spell_resource.name)

func upgrade_spell(upgrade_name):
	spells[upgrade_name].projectile_delay *= 0.95
	spells[upgrade_name].projectile_count += 1
	spells[upgrade_name].damage *= 1.25
	spells[upgrade_name].speed *= 1.05
	
func _exit_tree():
	for timer in timers:
		timers[timer].queue_free()

func can_cast_spell(spell_name: String):
	return spells.has(spell_name) and not timers[spell_name].is_stopped()

func cast_spell(spell_name: String, position: Vector2, direction: Vector2):
	#print ("Casting ", spell_name)
	#var num_missiles = 4
	#var timeout = spells[spell_name].cooldown / float(num_missiles)
	#for i in num_missiles:
	var spell = spells[spell_name].spell_scene.instantiate()
	spell.collision_layer = spell_collision_layer
	spell.collision_mask = spell_collision_mask
	spell.spell_resource = spells[spell_name]
	spell.position = position
	#spell.rotation = PI*2.0 / float(num_missiles)
	spell.direction = direction
	
	var sprite = get_spell_component(spell, "Sprite2D")
	if sprite:
		sprite.self_modulate = spells[spell_name].tint
	var particles = get_spell_component(spell, "GPUParticles2D")
	if particles:
		particles.self_modulate = spells[spell_name].tint
		
	get_parent().get_parent().add_child.call_deferred(spell)
	#await get_tree().create_timer(timeout).timeout

func get_spell_component(spell, type_name:String) -> Node:
	for child in spell.get_children():
		if child.get_class() == type_name:
			return child
	return null

func _on_spell_timer_timeout(spell_name: String):
	if Global.game_over:
		return
	#print("casting ", spell_name)
	var parent = get_parent()
	if not parent:
		print("no parent for spellbook!")
		return
	#print("parent is: ", parent.name)
	var pcount = spells[spell_name].projectile_count
	#print("pcount is ", pcount)
	
	var base_direction;
	if !spells[spell_name].random_direction:
		base_direction = parent.get_spell_casting_direction(spell_name).normalized()  
	else:
		base_direction = Vector2(randf()*2.0 - 1.0,randf()*2.0-1.0).normalized()
		
	var degree_offset =spells[spell_name].projectile_spread # degrees of separation between projectiles
	var radian_offset = deg_to_rad(degree_offset)  # Convert degrees to radians
	var half_offset_count = (pcount - 1) / 2.0  # Calculate half the number of offsets for symmetric distribution
	var projectile_delay = spells[spell_name].projectile_delay
	var direction_adjustment
	
	while pcount > 0:
		var index = pcount - 1
		if !spells[spell_name].random_direction:
			direction_adjustment = (index - half_offset_count) * radian_offset
		else:
			direction_adjustment = randf()*2.0*PI - 1.0*PI
			
		var direction = base_direction.rotated(direction_adjustment)
		var base_position = parent.get_spell_casting_position(spell_name)
		var position = base_position

		if parent.can_cast_spell(spell_name):
			cast_spell(spell_name, position, direction)
		else:
			print("not allowed to cast yet!")

		pcount -= 1
		#print ("wait start")
		await get_tree().create_timer(projectile_delay).timeout
		#print ("wait end")

