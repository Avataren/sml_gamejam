extends Path2D
@export var spawn_list:Array[PackedScene]
@export var spawn_interval:float = 1.0
@export var path_speed:= 0.1
var curr_path_pos := 0.0
var timer:Timer = Timer.new()
@onready var path_follow = %PathFollow2D
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	timer.set_wait_time(spawn_interval)
	timer.one_shot = false
	timer.timeout.connect(spawn)
	timer.start()
	
func spawn():
	if spawn_list.size() == 0 || !Global.tilemap || Global.enemy_count >= Global.max_enemies:
		return

	if !_get_valid_spawn_position():
		print ("No valid spawn position found")
		return
	print ("spawning creature")
	var new_spawn = spawn_list.pick_random().instantiate()
	new_spawn.global_position = path_follow.global_position
	get_parent().get_parent().add_child(new_spawn)
	
func _get_valid_spawn_position(): 
	for i in 10:
		var ppos = path_follow.global_position
		var tilemap = Global.tilemap
		var local_pos = tilemap.to_local(ppos)
		var no_spawn = get_custom_data_at(local_pos,"no_spawn")
		if (!no_spawn):
			return true
		path_follow.set_progress_ratio( path_follow.get_progress_ratio() + 0.1)
	
	
static func get_tile_data_at(position: Vector2) -> TileData:
	var local_position: Vector2 =  Global.tilemap.local_to_map(position)
	return  Global.tilemap.get_cell_tile_data(0, local_position)
	
static func get_custom_data_at(position: Vector2, custom_data_name: String) -> Variant:
	var data = get_tile_data_at(position)
	return data.get_custom_data(custom_data_name)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_follow.set_progress_ratio(path_follow.get_progress_ratio() + path_speed * delta)
	if path_follow.get_progress_ratio() > 1.0:
		path_follow.set_progress_ratio( path_follow.get_progress_ratio() - 1.0)
