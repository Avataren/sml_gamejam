extends Resource

class_name SpellResource

@export var name : String = "new spell"
@export var hitpoints : int = 1
@export var cooldown: float = 1.
@export var speed:float = 100.
@export var damage:float = 1.
@export var icon: Texture2D
@export var spell_scene: PackedScene
@export var life_time: float = 5.0
@export var radius: float = 100.0
@export var tint:Color = Color.WHITE
@export var projectile_count:int = 1
@export var projectile_spread:float = 10
@export var projectile_delay:float = 0.1
@export var random_direction:bool = false
