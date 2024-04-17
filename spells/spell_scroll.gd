extends Area2D
@export var spells_list:Array[SpellResource]
@export var pickup_effect:PackedScene
@export var upgrade_effect:PackedScene
@export var info_text:PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var new_spell = spells_list.pick_random()
		if body.spellbook.spells.has(new_spell.name):
			body.spellbook.upgrade_spell(new_spell.name)
			if info_text:
				var info = info_text.instantiate()
				info.label = new_spell.name + " was upgraded!"
				get_parent().get_parent().add_child.call_deferred(info)
			if upgrade_effect:
				var effect = pickup_effect.instantiate()
				get_parent().get_parent().add_child.call_deferred(effect)
		else:
			if info_text:
				var info = info_text.instantiate()
				info.label = "You have learned " + new_spell.name
				get_parent().get_parent().add_child.call_deferred(info)
				
			if pickup_effect:
				var effect = pickup_effect.instantiate()
				get_parent().get_parent().add_child.call_deferred(effect)
			body.spellbook.add_spell(new_spell)
		#var filtered_spells = spells_list.filter(func(item):
			#return not body.spellbook.spells.has(item.name)
		#)
		#if filtered_spells.size():
			#var spell = filtered_spells.pick_random()
			#print ("adding spell ", spell.name)
			#body.spellbook.add_spell(spell)
			#if pickup_effect:
				#var effect = pickup_effect.instantiate()
				#get_parent().get_parent().add_child(effect)
			#else:
				#print ("player has all spells")
		$Node2D.hide()
		$AudioStreamPlayer.play()
		await get_tree().create_timer(2.5).timeout
		queue_free()
