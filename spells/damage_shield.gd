extends BaseSpell

var projectile_velocity := Vector2(0,0)
@export var explosion:PackedScene
var explosion_instance
var rotating = true
var start_t
var t_speed = 2.5
func _ready():
	start_t = Time.get_unix_time_from_system() * t_speed
	super()
	print ("creating damage shield!")
	if $AudioStreamPlayer2D:
		$AudioStreamPlayer2D.play()

func _physics_process(_delta):
	global_position = Global.player.global_position
	var offset:Vector2 = Vector2(0.0,-40.0)
	var t = (Time.get_unix_time_from_system() * t_speed) - start_t
	$Sprite2D.position = Vector2(cos(t),sin(t))*radius + offset
	$CollisionShape2D.position = $Sprite2D.position + offset
	t+=PI*0.5
	$Sprite2D2.position = Vector2(cos(t),sin(t))*radius + offset
	$CollisionShape2D2.position = $Sprite2D2.position + offset
	t+=PI*0.5
	$Sprite2D3.position = Vector2(cos(t),sin(t))*radius + offset
	$CollisionShape2D3.position = $Sprite2D3.position + offset
	t+=PI*0.5
	$Sprite2D4.position = Vector2(cos(t),sin(t))*radius + offset
	$CollisionShape2D4.position = $Sprite2D4.position + offset
	
	
func impact_effect(pos):
	if (explosion):
		explosion_instance = explosion.instantiate();
		explosion_instance.global_position = pos 
		get_parent().add_child.call_deferred(explosion_instance)
		
func start_rotating():
	rotating = true
	
func death_effect():		
		#$GPUParticles2D.emitting = false
		$Sprite2D.visible = false
