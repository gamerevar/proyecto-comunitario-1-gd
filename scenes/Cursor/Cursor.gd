extends Node2D

enum Mode { 
	IDLE,
	UNIT_CAN_REACH,
	UNIT_CANT_REACH
}

export var navigation_2d_node_path : NodePath

var current_Mode = Mode.IDLE
var current_tile : Vector2
var current_unit : Area2D
var selected_unit : Area2D

onready var mouse_container := $MouseContainer #containes everything that moves with the Cursor
onready var Tile_container := $TileContainer #containes everything that moves depending the grid
onready var tile_map := get_parent()
onready var navigation_2d := get_node(navigation_2d_node_path)

func _ready()-> void:
	change_mode(Mode.IDLE)
	

func _unhandled_input(event)-> void:
	var mouse_position := get_global_mouse_position()
	current_tile = tile_map.world_to_map(mouse_position)
	
	mouse_container.global_position = mouse_position
	Tile_container.global_position = tile_map.map_to_world(current_tile)
	
	check_tile_state()
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and current_Mode == Mode.UNIT_CAN_REACH:
			create_and_send_path(tile_map.map_to_world(current_tile))
		
		#DELETE when units are seleted from an other place
		if event.button_index == BUTTON_LEFT and current_unit != null:
			set_unit(current_unit)
		
	

func change_mode(mode := Mode.NONE)-> void:
	current_Mode = mode
	match current_Mode:
		Mode.IDLE:
			$TileContainer/WalkTileSprite.visible = false
			$TileContainer/NotWalkTileSprite.visible = false
		Mode.UNIT_CAN_REACH:
			$TileContainer/WalkTileSprite.visible = true
			$TileContainer/NotWalkTileSprite.visible = false
		Mode.UNIT_CANT_REACH:
			$TileContainer/WalkTileSprite.visible = false
			$TileContainer/NotWalkTileSprite.visible = true
	

func check_tile_state()-> void:
	if selected_unit == null:
		return
	
	if tile_map.get_cellv(current_tile) == 2:
		change_mode(Mode.UNIT_CAN_REACH)
	else:
		change_mode(Mode.UNIT_CANT_REACH)

func create_and_send_path(endpoint)-> void:
	var start_point = selected_unit.global_position
	endpoint = endpoint + Vector2(0, 8) #for setting it in the middle of the tile
	
	var path = navigation_2d.get_simple_path(start_point, endpoint)
	
	selected_unit._update_way(path)

func set_unit(unit: Area2D = null):
	selected_unit = unit
	selected_unit.select() #DELETE just for testing.

#for storing wich unit the mouse is hovering.
#DELETE when units are seleted from an other place
func _on_AllyArea_area_entered(area)-> void:
	current_unit = area


func _on_AllyArea_area_exited(_area)-> void:
	current_unit = null
