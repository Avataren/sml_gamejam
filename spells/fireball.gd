extends BaseSpell

var projectile_velocity := Vector2(0,0)
@export var explosion:PackedScene
var explosion_instance

func _ready():
	super()
	if %AudioStreamPlayer2D:
		%AudioStreamPlayer2D.play()

func impact_effect(_pos):
	if (explosion):
		explosion_instance = explosion.instantiate();
		explosion_instance.global_position = global_position + Vector2(0,50)
		get_parent().add_child.call_deferred(explosion_instance)
		
func death_effect():		
	$GPUParticles2D.emitting = false
	$Sprite2D.visible = false
