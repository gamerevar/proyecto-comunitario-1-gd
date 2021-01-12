extends TileMap

const PARALLEL_NEIGHBORS := [Vector2(0, -1), Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0)] #N-S-E-W
const DIAGONALS_NEIGHBORS := [Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1), Vector2(-1, -1)] #NE-NW-SE-SW

onready var a_star = AStar2D.new()
onready var walkable_tiles = get_used_cells()
onready var min_x : int = walkable_tiles[0].x
onready var min_y : int = walkable_tiles[0].y

func _ready()-> void:
	for tile in walkable_tiles:
		if tile.x < min_x:
			min_x = tile.x
		if tile.y < min_y:
			min_y = tile.y
	
	create_points()
	connect_neighbors()

func create_points()-> void:
	for tile in walkable_tiles:
		a_star.add_point(get_tile_id(tile), tile, 1.0)

func connect_neighbors()-> void:
	for tile in walkable_tiles:
		
		for neighbor in PARALLEL_NEIGHBORS:
			var neighbor_tile : Vector2 = tile + neighbor
			if walkable_tiles.has(neighbor_tile):
				a_star.connect_points(get_tile_id(tile), get_tile_id(neighbor_tile),false)
		
		for neighbor in DIAGONALS_NEIGHBORS:
			var n_or_s : Vector2 = tile + Vector2(neighbor.x, 0)
			var e_or_w : Vector2 = tile + Vector2(0, neighbor.y)
			var neighbor_tile : Vector2 = tile + neighbor
			if n_or_s in walkable_tiles and e_or_w in walkable_tiles and neighbor_tile in walkable_tiles:
				a_star.connect_points(get_tile_id(tile), get_tile_id(tile + neighbor), false)

func get_reachable_tiles(center_tile : Vector2, max_range : int)-> Array:
	
	var in_range_tiles = []
	var reachable_tiles = []
	
	for x in range(center_tile.x - max_range, center_tile.x + max_range):
		for y in range(center_tile.y - max_range, center_tile.y + max_range):
			var tile_in_rage = Vector2(x, y)
			if walkable_tiles.has(tile_in_rage):
				in_range_tiles.append(tile_in_rage)
	
	for tile in in_range_tiles:
		var best_path = a_star.get_point_path(get_tile_id(center_tile), get_tile_id(tile))
		if best_path.size() < max_range + 1 and best_path.size() > 1:
			reachable_tiles.append(tile)
	
	return reachable_tiles

func get_astar_path_in_wolrd(start_tile : Vector2 , end_tile : Vector2)-> Array:
	var path = a_star.get_point_path(get_tile_id(start_tile), get_tile_id(end_tile))
	var final_path = []
	for point in path:
		point = map_to_world(point) + Vector2(0, 8) #TODO this is a offset to get the middle of the tile
		final_path.append(point)
	return final_path

func get_tile_id(tile : Vector2)-> int:
	var a : int = tile.x - min_x
	var b : int = tile.y - min_y
	return ( (a+b) * (a+b+1) )/2 + b
