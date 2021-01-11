extends Node2D

enum Mode { 
	IDLE,
	UNIT_CAN_REACH,
	UNIT_CANT_REACH
}

export var tile_map_hilight_node_path : NodePath

var current_mode = Mode.IDLE
var current_tile : Vector2
var current_unit : Area2D #DELETE this is just for testing.
var selected_unit : Area2D
var valid_tiles : Array

onready var mouse_container := $MouseContainer #containes everything that moves with the Cursor
onready var Tile_container := $TileContainer #containes everything that moves depending the grid
onready var tile_map_a_star := get_parent()
onready var tile_map_hilight := get_node(tile_map_hilight_node_path)

func _ready()-> void:
	change_mode(Mode.IDLE)

func _unhandled_input(event)-> void:
	var mouse_position := get_global_mouse_position()
	current_tile = tile_map_a_star.world_to_map(mouse_position)
	
	mouse_container.global_position = mouse_position
	Tile_container.global_position = tile_map_a_star.map_to_world(current_tile)
	
	check_tile_state()
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and current_mode == Mode.UNIT_CAN_REACH:
			send_path(current_tile)
			tile_map_hilight.clean_hilights()
		
		#DELETE this is just for testing.
		if event.button_index == BUTTON_LEFT and current_unit != null:
			set_unit(current_unit)
			valid_tiles = tile_map_a_star.get_reachable_tiles(tile_map_a_star.world_to_map(selected_unit.global_position), selected_unit.max_movement)
			tile_map_hilight.set_reachable_hilights(valid_tiles)
	

func change_mode(mode := Mode.NONE)-> void:
	current_mode = mode
	match current_mode:
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
		change_mode(Mode.IDLE)
	
	if valid_tiles.has(current_tile):
		change_mode(Mode.UNIT_CAN_REACH)
	else:
		change_mode(Mode.UNIT_CANT_REACH)
	

func send_path(end_point : Vector2)-> void:
	var start_point = tile_map_a_star.world_to_map(selected_unit.global_position)
	var path = tile_map_a_star.get_astar_path_in_wolrd(start_point, end_point)
	selected_unit.move(path)

func set_unit(unit: Area2D = null)-> void:
	selected_unit = unit
	if selected_unit != null:
		selected_unit.select() #DELETE this is just for testing.
	

#for storing wich unit the mouse is hovering.
#DELETE this is just for testing.
func _on_AllyArea_area_entered(area)-> void:
	current_unit = area

func _on_AllyArea_area_exited(_area)-> void:
	current_unit = null
