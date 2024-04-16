extends Resource

class_name SpellResource

@export var name : String = "new spell"
@export var hitpoints : int = 1
@export var cooldown: float = 1.
@export var speed = 100.
@export var damage = 1.
@export var icon: Texture2D
@export var spell_scene: PackedScene
@export var life_time: float = 5.0
@export var radius: float = 100.0
@export var tint:Color = Color.WHITE
@export var projectile_count:int = 1
@export var projectile_spread:float = 10
