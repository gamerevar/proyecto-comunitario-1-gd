extends Node2D

export var navigation_2d_node_path : NodePath

var selected_tile : Vector2
var current_tile : Vector2
var selected_unit : Area2D
var current_unit : Area2D

onready var mouse_container := $MouseContainer #containes everything that moves with the Cursor
onready var Tile_container := $TileContainer #containes everything that moves depending the grid
onready var tile_map := get_parent()
onready var navigation_2d := get_node(navigation_2d_node_path)

func _unhandled_input(event):
	var mouse_position := get_global_mouse_position()
	
	mouse_container.global_position = mouse_position
	current_tile = tile_map.world_to_map(mouse_position)
	
	if is_valid_tile(current_tile): 
		update_selected_tile(current_tile)
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and selected_unit != null:
			create_and_send_path(tile_map.map_to_world(selected_tile))
		
		#this is just for testing. and picking a unit by clicking
		if event.button_index == BUTTON_LEFT and current_unit != null:
			selected_unit = current_unit
			selected_unit.select()
		
	

func update_selected_tile(tile)-> void:
	selected_tile = tile
	Tile_container.global_position = tile_map.map_to_world(selected_tile)

func is_valid_tile(tile)-> bool:
	#this might need change depending the how we finaly set the tilemaps
	if tile_map.get_cellv(tile) == 2:
		return true
	return false

func create_and_send_path(endpoint)-> void:
	var start_point = selected_unit.global_position
	endpoint = endpoint + Vector2(0, 8) #for setting it in the middle of the tile
	
	var path = navigation_2d.get_simple_path(start_point, endpoint)
	path.remove(0)# Because Unit dont need current position.
	
	selected_unit._update_way(path)

#for storing wich unit the mouse is hovering over
func _on_AllyArea_area_entered(area)-> void:
	current_unit = area

func _on_AllyArea_area_exited(area)-> void:
	current_unit = null
