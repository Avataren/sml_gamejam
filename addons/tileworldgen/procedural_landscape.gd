@tool
extends EditorScript

const WIDTH = 512
const HEIGHT = 512

var _seed

func create_procedural_map(tilemap:TileMap):
	tilemap.clear();
	var noise = FastNoiseLite.new()
	print ("Seed:", _seed)
	noise.seed = _seed
	noise.fractal_octaves = 5
	noise.frequency  = 0.005
	for y in range (-HEIGHT/2,HEIGHT/2):
		for x in range (-WIDTH/2,WIDTH/2):
			var h = noise.get_noise_2d(x,y)
			if (h < -0.1):
				BetterTerrain.set_cell(tilemap, 0, Vector2i(x,y), 0)
			#elif h < 0.3:
			else:
				BetterTerrain.set_cell(tilemap, 0, Vector2i(x,y), 1)
			#else:
				#BetterTerrain.set_cell(tilemap, 0, Vector2i(x,y), 2)
	print("Generation completed! updating cells..")	
	BetterTerrain.update_terrain_area(tilemap, 0, Rect2i(-WIDTH/2,-HEIGHT/2,WIDTH,HEIGHT))
	print("Done")

func generate_landscape(seed):
	_seed = seed
	for node in get_all_children(get_scene()):
		if node is TileMap:
			print("Found tilemap!")
			create_procedural_map(node)
			# Don't operate on instanced subscene children, as changes are lost
			# when reloading the scene.
			# See the "Instancing scenes" section below for a description of `owner`.
			#var is_instanced_subscene_child = node != get_scene() and node.owner != get_scene()
			#/if not is_instanced_subscene_child:
				#node.omni_range *= 2.0

# This function is recursive: it calls itself to get lower levels of child nodes as needed.
# `children_acc` is the accumulator parameter that allows this function to work.
# It should be left to its default value when you call this function directly.
func get_all_children(in_node, children_acc = []):
	children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_children(child, children_acc)

	return children_acc
