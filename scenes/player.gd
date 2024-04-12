extends CharacterBody2D

const SPEED = 100.0
@onready var sprite = %Sprite2D

var missile:PackedScene = load("res://spells/missile.tscn")
var missile_timer := Timer.new()
@onready var player_area:Area2D = %Area2D
func _ready():
	Global.player = self
	add_child(missile_timer)
	missile_timer.wait_time = 0.25
	missile_timer.one_shot = false
	missile_timer.start()
	missile_timer.timeout.connect(_shoot_missile)
	
func _shoot_missile():
	var enemies = player_area.get_overlapping_bodies()
	var closest_enemy;
	var closest = INF
	var staff_pos = %StaffPosition.global_position
	for enemy in enemies:
		var enemy_dist = staff_pos.distance_to(enemy.global_position)
		if (enemy_dist < closest):
			closest = enemy_dist
			closest_enemy = enemy
	
	
	var m:Area2D = missile.instantiate()
	m.position = %StaffPosition.global_position
	
	if (closest_enemy):
		m.direction = (closest_enemy.global_position - staff_pos).normalized()
	else:
		m.direction = Vector2(randf_range(-1., 1,), randf_range(-1., 1.)).normalized()
		
	get_parent().add_child(m)
	
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	move_and_slide()
	# Check for horizontal movement
	if direction.x > 0:
		sprite.scale.x = -1  # Assuming your sprite faces left by default
	elif direction.x < 0:
		sprite.scale.x = 1

func _process(delta):
	pass


func _on_area_2d_area_exited(area):
	if (area.is_in_group("spell")):
		area.queue_free()
