extends Camera2D

#signals
signal anchor_reached

#enums
enum CameraState {
	ANCHOR,
	MOUSE_WASD,
}

#exported variables
export(float, 0, 1) var tolerance: float = 0.5 #workaround for multi monitor
export(float, 0, 1000) var speed: float = 500
export(CameraState) var current_state

#onready variables
onready var tween := $Tween


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # Mouse is visible and can't go out screen


func _process(delta) -> void:
	if current_state != CameraState.ANCHOR:
		var direction := _get_keyboard_direction()
		if direction.is_equal_approx(Vector2.ZERO):
			direction = _get_cursor_direction()
		position +=  direction * speed * delta


func set_anchor(target_node:Node2D) -> void:
	var anchor: Vector2 = get_parent().to_local(target_node.global_position)
	current_state = CameraState.ANCHOR
	var anchor_distance := position.distance_to(anchor)
	var time := anchor_distance / speed
	tween.interpolate_property(self,"position",position,anchor,time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _get_keyboard_direction() -> Vector2:
	var keyboard_direction := Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		keyboard_direction.x -= 1 # LEFT
	elif Input.is_action_pressed("ui_right"):
		keyboard_direction.x += 1 # RIGHT
	if Input.is_action_pressed("ui_up"):
		keyboard_direction.y -= 1 #UP
	elif Input.is_action_pressed("ui_down"):
		keyboard_direction.y += 1 #DOWN
	return keyboard_direction.normalized()


func _get_cursor_direction() -> Vector2:
	var viewport := get_viewport()
	var viewport_size := viewport.size
	var pos_on_viewport := get_viewport().get_mouse_position()
	var min_pos := 0.0
	var max_pos_x := viewport_size.x
	var max_pos_y := viewport_size.y
	var cursor_direction := Vector2.ZERO
	if pos_on_viewport.x >= min_pos and pos_on_viewport.x <= tolerance:
		cursor_direction.x -= 1 # LEFT
	elif pos_on_viewport.x >= max_pos_x - tolerance and pos_on_viewport.x <= max_pos_x :
		cursor_direction.x += 1 # RIGHT
	if pos_on_viewport.y >= min_pos and pos_on_viewport.y <= tolerance:
		cursor_direction.y -= 1 #UP
	elif pos_on_viewport.y >= max_pos_y - tolerance and pos_on_viewport.y <= max_pos_y :
		cursor_direction.y += 1 #DOWN
	return cursor_direction.normalized()

func _on_anchor_reached(object, key) -> void:
	emit_signal("anchor_reached")
	current_state = CameraState.MOUSE_WASD
