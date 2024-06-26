extends EditorScript

var _width = 512
var _height = 512
const THREAD_COUNT = 8
var _seed := 123
var _octaves := 5
var _frequency := 0.005
var threads := []
var noise = FastNoiseLite.new()
# Array to hold all changes, preallocated to the total number of cells

const GROUND_LAYER = 0
const GRASS_LAYER = 1
const FAUNA_LAYER = 2
const TREE_LAYER = 3

const TILEMAP_SIZE = 64

var tilemaps = {}

func _init():
	print("Init called")
	# Pre-create threads
	for i in range(THREAD_COUNT):
		threads.append(Thread.new())
	# Properly preallocate all_changes with placeholder values for each cell
	#for i in range(WIDTH * HEIGHT):
		#all_changes.append({"position": Vector2i(), "value": 0, "terrain": 0})

		
func create_procedural_map(tilemap: TileMap, lit_tilemap: TileMap):
	tilemaps = {Vector2i(0,0): tilemap}
	
	var start_time = Time.get_ticks_msec()
	if lit_tilemap:
		lit_tilemap.clear()
	if tilemap:
		tilemap.clear()
		
	noise.seed = _seed
	noise.fractal_octaves = _octaves
	noise.frequency = _frequency    
	var section_height = _width / THREAD_COUNT
	var all_changes = []
	
	for i in range(THREAD_COUNT):
		var start_y = -_height / 2 + i * section_height
		var end_y = start_y + section_height
		# Calculate the start index for this section in the all_changes array
		#var start_index = i * WIDTH * section_height
		threads[i].start(_thread_function.bind(tilemap, start_y, end_y))
		
	print("Waiting for threads to finish")
	var thread_results = []
	for thread in threads:
		var data = thread.wait_to_finish();
		thread_results.append(data)
		
	for result in thread_results:
		all_changes+=result	
		
	#for i in range(THREAD_COUNT):
		#var start_y = -_height / 2 + i * section_height
		#var end_y = start_y + section_height
		## Calculate the start index for this section in the all_changes array
		##var start_index = i * WIDTH * section_height
		#threads[i].start(_thread_function.bind(lit_tilemap, start_y, end_y, false))
		#
	#print("Waiting for threads to finish")
	#thread_results = []
	#for thread in threads:
		#var data = thread.wait_to_finish();
		#thread_results.append(data)
		#
	#for result in thread_results:
		#all_changes+=result			
	#
	#
	
	var end_time = Time.get_ticks_msec() # End timing
	var duration = end_time - start_time # Calculate duration
	start_time = Time.get_ticks_msec()
	print("procedural gen done. Duration: ", duration, " ms")    
#
	print("Applying changes")
	for change in all_changes:
		if change:
			BetterTerrain.set_cell(tilemap, change.layer, change.position, change.terrain)
	end_time = Time.get_ticks_msec() # End timing
	duration = end_time - start_time # Calculate duration
	start_time = Time.get_ticks_msec()
	print("Updating cells.. ", duration, " ms")
	BetterTerrain.update_terrain_area(tilemap, GROUND_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))
	BetterTerrain.update_terrain_area(tilemap, GRASS_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))
	BetterTerrain.update_terrain_area(tilemap, FAUNA_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))
	BetterTerrain.update_terrain_area(tilemap, TREE_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))
	
	#BetterTerrain.update_terrain_area(lit_tilemap, GROUND_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))
	#BetterTerrain.update_terrain_area(lit_tilemap, GRASS_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))
	#BetterTerrain.update_terrain_area(lit_tilemap, FAUNA_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))
	#BetterTerrain.update_terrain_area(lit_tilemap, TREE_LAYER, Rect2i(-_width / 2, -_height / 2, _width, _height))	
	#var source = tilemap.tile_set.get_source(7) as TileSetAtlasSource
	#print ("source is ", source)
	#print ("tile count:",source.get_tiles_count() )
	#for i in source.get_tiles_count():
		#var coords = source.get_tile_id(i)
		#var tile_data = source.get_tile_data(coords, 0)
		#var occlusion_polygon = tile_data.get_occluder(0)
		#if (occlusion_polygon):
			#print("updateing cullmode")
					## and set the cull_mode to counter clockwise
			#occlusion_polygon.cull_mode = OccluderPolygon2D.CULL_COUNTER_CLOCKWISE
					
	end_time = Time.get_ticks_msec() # End timing
	duration = end_time - start_time # Calculate duration
	print("Done. Duration for terrain update: ", duration, " ms")    

func _thread_function(tilemap, start_y, end_y, has_shadow = true):
	var changes = []
	for y in range(start_y, end_y):
		for x in range(-_width / 2, _width / 2):
			var h = noise.get_noise_2d(x, y)
			if (has_shadow):
				if h < -0.1:
					changes.append ({"position": Vector2i(x, y), "layer": GROUND_LAYER, "terrain": 0})
				else:
					changes.append({"position": Vector2i(x, y), "layer": GROUND_LAYER, "terrain": 1})

			if (h > 0.1):# && !has_shadow):
				if randi_range(0, 100) <= 1:
					changes.append({"position": Vector2i(x, y), "layer": TREE_LAYER, "terrain": 6})
	
			if (has_shadow):
				if (h > 0.25):
					#if randi_range(0, 100) <= 85:
						changes.append({"position": Vector2i(x, y), "layer": GRASS_LAYER, "terrain": 5})
				
				if (h > -0.05):
					if randf() > 0.7:
						changes.append({"position": Vector2i(x, y), "layer": FAUNA_LAYER, "terrain": 3})
				if (h < -0.13 && h > -0.145):
					if randf() > 0.9:
						changes.append({"position": Vector2i(x, y), "layer": FAUNA_LAYER, "terrain": 4})
					
	return changes
			
	
func generate_landscape(seed, octaves, frequency, width, height):
	_seed = seed
	_octaves = octaves
	_frequency = frequency
	_width = width
	_height = height
	var world_tilemap:TileMap;
	var lit_tilemap:TileMap;
	for node in get_all_children(get_scene()):
		if node is TileMap:
			if node.name == "WorldTileMap":
				world_tilemap = node
				print ("found world tilemap")
			elif node.name == "LitTilemap":
				lit_tilemap = node
	print("Found tilemap!")
	create_procedural_map(world_tilemap, lit_tilemap)

func get_all_children(in_node, children_acc = []):
	children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_children(child, children_acc)

	return children_acc
