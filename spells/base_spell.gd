# BaseSpell.gd
extends Area2D
class_name BaseSpell

@export var spell_resource: SpellResource

var direction = Vector2(1, 0)  # Default direction; should be set during instantiation based on caster's facing or target.
var speed = 100.0
var hitpoints = 1
var life_started := 0.
var life_time = 5.0
var radius = 800.0

func _ready():
	life_started = Time.get_unix_time_from_system()
	add_to_group("spell")
	speed = spell_resource.speed if spell_resource else speed
	life_time = spell_resource.life_time if spell_resource else life_time
	radius = spell_resource.radius if spell_resource else radius
	print("speed is ", speed)
	hitpoints = spell_resource.hitpoints if spell_resource else 1
	
func _process(delta):
	if (Time.get_unix_time_from_system() - life_started) > life_time:
		queue_free()
	#print ("speed:",speed)
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if (area.name == "PlayerBoundsArea"):
		return
	
	#print ("area layer:", area.collision_layer)
	#print ("this mask:", collision_mask)
	
	var body = area.get_parent()
	#print ("parent is ", body.name)
	if body is CharacterBody2D:
		if body.has_method("hit"):
			body.hit(spell_resource.damage)
			impact_effect(body.global_position)
			hitpoints -= 1
			if (hitpoints <= 0):
				death_effect()
				_die()		
	else:
		impact_effect(global_position)
		hitpoints -= 1
		
		
	
func _on_body_entered(body):
	pass

func death_effect():
	pass

func impact_effect(pos):
	pass
	
func _die():
	queue_free()
