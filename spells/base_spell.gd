# BaseSpell.gd
extends Area2D
class_name BaseSpell

@export var spell_resource: SpellResource

var direction = Vector2(1, 0)  # Default direction; should be set during instantiation based on caster's facing or target.
var speed = 100.0
var hitpoints = 1

func _ready():
	add_to_group("spell")
	$GPUParticles2D.emitting = true
	speed = spell_resource.speed if spell_resource else speed
	hitpoints = spell_resource.hitpoints if spell_resource else 1

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if (area.name == "PlayerBoundsArea"):
		return
	#print ("colliding with : ", area.name)
	#print ("area layer:", area.collision_layer)
	#print ("this mask:", collision_mask)
	
	var body = area.get_parent()
	#print ("parent is ", body.name)
	if body is CharacterBody2D:
		if body.has_method("hit"):
			print ("hitting ", body.name)
			body.hit(spell_resource.damage)
			impact_effect()
			hitpoints -= 1
			if (hitpoints <= 0):
				death_effect()
				_die()		
	else:
		impact_effect()
		hitpoints -= 1
		
		
	
func _on_body_entered(body):
	pass

func death_effect():
	pass

func impact_effect():
	pass
	
func _die():
	queue_free()
