extends CharacterBody2D
@export var attack_distance := 50.0

func _ready():
	add_to_group("enemies")
	_play_animation_rnd("idle")
	
func _play_animation_rnd(animation_name):
	if ($AnimationPlayer.current_animation == animation_name):
		return
	# Get the length of the animation
	var animation_length = $AnimationPlayer.get_animation(animation_name).get_length()
	# Generate a random starting point
	var random_start = randf() * animation_length
	# Seek to the random start point in the animation
	$AnimationPlayer.play(animation_name)
	$AnimationPlayer.seek(random_start, true)	
	
func _physics_process(delta):
	if (Global.player):
		var direction = global_position.direction_to(Global.player.global_position)	
		var distance = global_position.distance_to(Global.player.global_position)
		
		
		velocity = direction * 50.0
		move_and_slide()
		
		if direction.x > 0:
			%mob_sprite.scale.x = 1  # Assuming your sprite faces right by default
		elif direction.x < 0:
			%mob_sprite.scale.x = -1
	
		if (distance < attack_distance):
			$AnimationPlayer.play("attack")
		elif (velocity.length() < 0.01):
			_play_animation_rnd("idle")
		else:
			_play_animation_rnd("walk")
