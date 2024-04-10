extends CharacterBody2D

const SPEED = 100.0
@onready var sprite = %Sprite2D
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	move_and_slide()
	# Check for horizontal movement
	if direction.x > 0:
		sprite.scale.x = -1  # Assuming your sprite faces left by default
	elif direction.x < 0:
		sprite.scale.x = 1
