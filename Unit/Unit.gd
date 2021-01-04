class_name Unit
extends Area2D

#Stats
export var speed: int 
export var health: int 
export var atack_range: int 
export var min_damage: int 
export var max_damage: int 

#Experimental location
onready var camino := PoolVector2Array()

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
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camino.append(Vector2(270, 119))

func _process(delta) -> void:
	_move(camino, delta)
