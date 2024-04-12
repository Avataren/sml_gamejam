extends Area2D

var projectile_velocity := Vector2(0,0)
var speed = 200
var hitpoints = 1
var direction:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("spell")
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
			queue_free()
#	if (body.is_in_group("enemy")):
#		print ("hit")
