extends BaseSpell

var projectile_velocity := Vector2(0,0)
@export var explosion:PackedScene
var explosion_instance
var rotating = true
func _ready():
	super()
	print ("creating damage shield!")
	if $AudioStreamPlayer2D:
		$AudioStreamPlayer2D.play()

func _physics_process(delta):
	global_position = Global.player.global_position
	#if rotating:
	var t = Time.get_unix_time_from_system() * 2.5
	$Sprite2D.position = Vector2(cos(t),sin(t))*radius
	$CollisionShape2D.position = $Sprite2D.position
	t+=PI*0.5
	$Sprite2D2.position = Vector2(cos(t),sin(t))*radius
	$CollisionShape2D2.position = $Sprite2D2.position
	t+=PI*0.5
	$Sprite2D3.position = Vector2(cos(t),sin(t))*radius
	$CollisionShape2D3.position = $Sprite2D3.position
	t+=PI*0.5
	$Sprite2D4.position = Vector2(cos(t),sin(t))*radius
	$CollisionShape2D4.position = $Sprite2D4.position
	
	
func impact_effect(pos):
	if (explosion):
		explosion_instance = explosion.instantiate();
		explosion_instance.global_position = pos 
		get_parent().add_child(explosion_instance)
		
func start_rotating():
	rotating = true
	
func death_effect():		
		#$GPUParticles2D.emitting = false
		$Sprite2D.visible = false
