extends Area2D
@export var spells_list:Array[SpellResource]
@export var pickup_effect:PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var filtered_spells = spells_list.filter(func(item):
			return not body.spellbook.spells.has(item.name)
		)
		
		var spell = filtered_spells.pick_random()
		if spell:
			print ("adding spell ", spell.name)
			body.spellbook.add_spell(spell)
			if pickup_effect:
				var effect = pickup_effect.instantiate()
				get_parent().get_parent().add_child(effect)
		else:
			print ("player has all spells")
		queue_free()
