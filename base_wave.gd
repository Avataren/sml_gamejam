extends Path2D
class_name BaseWave

@export var spawn_list:Array[PackedScene]
@export var boss_spawn_list:Array[PackedScene]
@export var spawn_interval:float = 0.5
@export var boss_spawn_interval:float = 50.0
@export var path_speed:= 0.15
@export var max_enemies_in_wave:int = 100
@export var wave_duration:int = 60

var curr_path_pos := 0.25
var timer:Timer = Timer.new()
var boss_timer:Timer = Timer.new()
@onready var path_follow = %PathFollow2D
var noise:FastNoiseLite = FastNoiseLite.new()
var noise_progress := 0.0

func _ready() -> void:
	add_child(timer)
	timer.set_wait_time(spawn_interval)
	timer.one_shot = false
	timer.timeout.connect(spawn)
	timer.start()
	
	add_child(boss_timer)
	boss_timer.set_wait_time(boss_spawn_interval)
	boss_timer.one_shot = false
	boss_timer.timeout.connect(spawn_boss)
	boss_timer.start()		

func spawn():
	if spawn_list.size() == 0 || !Global.tilemap || Global.enemy_count >= Global.max_enemies || Global.enemy_count >= max_enemies_in_wave:
		return
	if !_get_valid_spawn_position():
		print ("No valid spawn position found")
		return
	call_deferred("do_spawn")
	
func do_spawn():
	var new_spawn = spawn_list.pick_random().instantiate()
	new_spawn.global_position = path_follow.global_position
	get_parent().get_parent().add_child(new_spawn)
	
func spawn_boss():
	
	# dont' count bosses towards global enemy count
	if boss_spawn_list.size() == 0:
		return
	if !_get_valid_spawn_position():
		print ("No valid spawn position found")
		return
	for boss in boss_spawn_list:
		if !_get_valid_spawn_position():
			continue
		var new_spawn = boss.instantiate()
		new_spawn.global_position = path_follow.global_position
		get_parent().get_parent().add_child.call_deferred(new_spawn)	
		path_follow.set_progress_ratio( path_follow.get_progress_ratio() + 0.1)
		
func _get_valid_spawn_position(): 
	for _i in 20:
		var ppos = path_follow.global_position
		var tilemap = Global.tilemap
		var local_pos = tilemap.to_local(ppos)
		var offsets:Array[Vector2] = [Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1),Vector2(0,1), Vector2(0,-1), Vector2(1,1), Vector2(1,0), Vector2(1,-1)]
		var no_spawn =  get_custom_data_at(local_pos,"no_spawn")
		if !no_spawn:
			for offset in offsets:
				var no_spawn_sample = get_custom_data_at(local_pos+offset,"no_spawn")
				no_spawn = no_spawn || no_spawn_sample
				if no_spawn:
					break
				
		if (!no_spawn):
				return true		
		path_follow.set_progress_ratio( path_follow.get_progress_ratio() + 0.05)
	return false
	
static func get_tile_data_at(pos: Vector2) -> TileData:
	var local_position: Vector2 =  Global.tilemap.local_to_map(pos)
	return  Global.tilemap.get_cell_tile_data(0, local_position)
	
static func get_custom_data_at(pos: Vector2, custom_data_name: String) -> Variant:
	var data = get_tile_data_at(pos)
	if data:
		return data.get_custom_data(custom_data_name)
	return true
		
func _process(delta):
	var noise_path = 1.0 + noise.get_noise_1d(noise_progress)
	noise_progress+= path_speed * delta
	
	path_follow.set_progress_ratio(noise_path)
	if path_follow.get_progress_ratio() > 1.0:
		path_follow.set_progress_ratio( path_follow.get_progress_ratio() - 1.0)
