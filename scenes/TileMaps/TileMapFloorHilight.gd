extends TileMap

#mayby we can make a dictionary with the tiles if we need to add more types

func set_reachable_hilights(tiles_to_paint)-> void:
	for tile in tiles_to_paint:
		set_cell(tile.x, tile.y, 0)

func clean_hilights()-> void:
	for tile in get_used_cells():
		set_cell(tile.x, tile.y, -1)
