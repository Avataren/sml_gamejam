extends Area2D

var projectile_velocity := Vector2(0,0)
var speed = 200
var hitpoints = 1
var direction:Vector2
@export var explosion:PackedScene
var explosion_instance
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("spell")
	$GPUParticles2D.emitting = true
	#Vector2(randf_range(-1., 1,), randf_range(-1., 1.)).normalized() * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position +=  direction * speed * delta


func _on_body_entered(body):
#	print ("hit:", body)
	if (body.has_method("hit")):
		body.hit(1)
		hitpoints-=1
		if (hitpoints <= 0):
			if (explosion):
				print ("Explode!")
				explosion_instance = explosion.instantiate();
				explosion_instance.global_position = global_position + Vector2(0,50)
				#+ Vector2(0,$GPUParticles2D.process_material.emission_shape_offset.y) 
				#expl.Particles.process_material.emission_shape_offset =$GPUParticles2D.process_material.emission_shape_offset 
				get_parent().add_child(explosion_instance)
				
				$GPUParticles2D.emitting = false
				$Sprite2D.visible = false
			_die()

func _die():
	print ("missile death")
	queue_free()
