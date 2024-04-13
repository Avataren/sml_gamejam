# Spellbook.gd
extends Node
class_name Spellbook

signal spell_cast(spell)

var spells = {}  # Dictionary to hold SpellResources by name
var timers = {}  # Dictionary to hold timers for each spell

var spell_collision_layer = 1
var spell_collision_mask = 1

func add_spell(spell_resource: SpellResource):
	spells[spell_resource.name] = spell_resource
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(spell_resource.cooldown)
	timer.set_one_shot(false)
	timer.start()
	var callable = Callable(self, "_on_spell_timer_timeout").bind(spell_resource.name)
	timer.timeout.connect(callable)
	timers[spell_resource.name] = timer

func _exit_tree():
	for timer in timers:
		timers[timer].queue_free()

func can_cast_spell(spell_name: String):
	return spells.has(spell_name) and not timers[spell_name].is_stopped()

func cast_spell(spell_name: String, position: Vector2, direction: Vector2):
	#if can_cast_spell(spell_name):
	var spell = spells[spell_name].spell_scene.instantiate()
	spell.collision_layer = spell_collision_layer
	spell.collision_mask = spell_collision_mask
	spell.spell_resource = spells[spell_name]
	spell.position = position
	spell.direction = direction
	get_parent().get_parent().add_child(spell)

func _on_spell_timer_timeout(spell_name: String):
	var direction = get_parent().get_spell_casting_direction(spell_name)
	var position = get_parent().get_spell_casting_position(spell_name) 
	cast_spell(spell_name, position, direction)
