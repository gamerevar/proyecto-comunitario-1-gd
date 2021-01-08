class_name TestPlayer
extends Area2D

var max_movement = 4
var selected = false

func get_max_movement():
	return max_movement

func move(path):
	for point in path:
		$"Tween".interpolate_property($".", "global_position", position, point, 0.5, Tween.TRANS_LINEAR)
		$"Tween".start()
		yield(get_tree().create_timer(0.5), "timeout")

func select():
	selected = true
	$base_soldier.modulate = Color(0.972549, 0.105882, 0.105882)

func _on_Player_mouse_entered():
	if not selected:
		$base_soldier.modulate = Color(0.545098, 0.968627, 0.376471)

func _on_Player_mouse_exited():
	if not selected:
		$base_soldier.modulate = Color(1, 1, 1)
