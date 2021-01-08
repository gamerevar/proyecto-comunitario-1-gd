class_name Unit
extends Area2D

#Stats
export var speed: int 
export var health: int 
export var atack_range: int 
export var min_damage: int 
export var max_damage: int 

#Experimental location
onready var way : PoolVector2Array

func _move(coords: PoolVector2Array, delta) -> void:
		# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta
	
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and coords.size() > 0:
		var distance_to_next_point = position.distance_to(coords[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(coords[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = coords[0]
			coords.remove(0)
		distance_to_walk -= distance_to_next_point

func _ready() -> void:
	pass

func _process(delta) -> void:
	_move(way, delta)

#functions for testing Cursors.
func select():
	$Sprite.modulate = Color(0.972549, 0.105882, 0.105882)

func _update_way(path : PoolVector2Array):
	for point in path:
		way.append(point)
