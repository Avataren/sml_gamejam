# Spellbook.gd
extends Node
class_name Spellbook

signal spell_cast(spell)

var spells = {}  # Dictionary to hold SpellResources by name
var timers = {}  # Dictionary to hold timers for each spell

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
	print ("Added spell ", spell_resource.name)

func can_cast_spell(spell_name: String):
	return spells.has(spell_name) and not timers[spell_name].is_stopped()

func cast_spell(spell_name: String, position: Vector2, direction: Vector2):
	#if can_cast_spell(spell_name):
	var spell = spells[spell_name].spell_scene.instantiate()
	spell.position = position
	spell.direction = direction
	get_tree().root.add_child(spell)

func _on_spell_timer_timeout(spell_name: String):
	print ("spell parent :", get_parent())
	#if owner and can_cast_spell(spell_name):
	
	var direction = get_parent().get_spell_casting_direction(spell_name)
	print ("direction:", direction)
	var position = get_parent().get_spell_casting_position(spell_name) 
	print ("position:", position)
	cast_spell(spell_name, position, direction)
