extends Node2D

@export var label = "Infotext goes here"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Control/HBoxContainer/MarginContainer/Label.text = label
	$AnimationPlayer.play("text_anim")
	$AnimationPlayer.animation_finished.connect(_die)

func _die(_anim):
	queue_free()
