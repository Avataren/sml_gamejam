# Global.gd

extends Node

# Player instance variable
var player
var game_over
var tilemap:TileMap
var enemy_count:int = 0
var max_enemies:int = 200


func _ready():
	game_over=false
