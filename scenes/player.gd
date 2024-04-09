extends CharacterBody2D

const SPEED = 100.0
@onready var sprite = %Sprite2D
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	if (velocity.x > 0.1):
		sprite.flip_h = true
	elif (velocity.x < -0.1):
		sprite.flip_h = false
		
	move_and_slide()
