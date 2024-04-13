# BaseSpell.gd
extends Area2D
class_name BaseSpell

@export var spell_resource: SpellResource

var direction = Vector2(1, 0)  # Default direction; should be set during instantiation based on caster's facing or target.
var speed = 100.0

func _ready():
	add_to_group("spell")
	$GPUParticles2D.emitting = true
	$Sprite.texture = load(spell_resource.icon_path) if spell_resource.icon_path else $Sprite.texture
	speed = spell_resource.speed if spell_resource else speed

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(spell_resource.damage)
		if spell_resource.explosion_scene:
			var explosion_instance = spell_resource.explosion_scene.instance()
			explosion_instance.global_position = global_position
			get_parent().add_child(explosion_instance)
			$GPUParticles2D.emitting = false
			$Sprite.visible = false
		_die()

func _die():
	queue_free()
