extends Node2D

var selected_tile : Vector2
var current_tile : Vector2

var selected_unit : Area2D = null
var current_unit : Area2D

onready var mouse_container := $MouseContainer #containes everything that moves white the Cursor
onready var Tile_container := $TileContainer #containes everything that moves depending the grid
onready var tile_map := get_parent()
onready var navigation2D := get_parent().get_parent().get_parent()

func _input(event):
	var mouse_position := get_global_mouse_position()
	mouse_container.global_position = mouse_position
	current_tile = tile_map.world_to_map(mouse_position)
	
	if is_valid_tile(current_tile): 
		update_selected_tile(current_tile)
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and current_unit != null:
			selected_unit = current_unit
			selected_unit.select() #CHANGE
		
		if event.button_index == BUTTON_RIGHT and selected_unit != null:
			create_path(tile_map.map_to_world(selected_tile))
	

func update_selected_tile(tile):
	selected_tile = tile
	Tile_container.global_position = tile_map.map_to_world(selected_tile)

func is_valid_tile(tile):
	if tile_map.get_cellv(tile) == 2: #CHANGE
		return true
	return false

func create_path(endpoint):
	var path = navigation2D.get_simple_path(selected_unit.global_position, endpoint)
	selected_unit.move(path)

func _on_AllyArea_area_entered(area):
	current_unit = area

func _on_AllyArea_area_exited(area):
	current_unit = null
