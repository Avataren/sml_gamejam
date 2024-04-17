extends BaseSpell

var projectile_velocity := Vector2(0,0)
@export var explosion:PackedScene
var explosion_instance
var rotating = true
	
func impact_effect(pos):
	if (explosion):
		explosion_instance = explosion.instantiate();
		explosion_instance.global_position = pos 
		get_parent().add_child.call_deferred(explosion_instance)
		
func start_rotating():
	rotating = true
	
func death_effect():		
	#$GPUParticles2D.emitting = false
	pass
