extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles.emitting = true
	%PointLight2D.create_tween().tween_property(%PointLight2D,"texture_scale",0,0.5)

func _on_particles_finished():
	queue_free()
