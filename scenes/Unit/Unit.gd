class_name Unit
extends Area2D

export var movement_range : int = 4
export var atack_range : int
export var hit_points : int
export var damage_min : int
export var damage_max : int

var speed := 100.0
var selected := false
var action_points := 2

onready var soldier_sprite := $Sprite
onready var movement_tween := $"Tween"

func move(path)-> void:
	path.remove(0)
	for point in path:
		var time := position.distance_to(point) / speed
		movement_tween.interpolate_property($".", "global_position", position, point, time, Tween.TRANS_LINEAR)
		movement_tween.start()
		yield(movement_tween,"tween_all_completed")

func select()-> void:
	selected = true
	soldier_sprite.modulate = Color(0.972549, 0.105882, 0.105882)

func unselect()-> void:
	selected = false
	soldier_sprite.modulate = Color(1, 1, 1)

func _on_Player_mouse_entered()-> void:
	if not selected:
		soldier_sprite.modulate = Color(0.545098, 0.968627, 0.376471)

func _on_Player_mouse_exited()-> void:
	if not selected:
		soldier_sprite.modulate = Color(1, 1, 1)
