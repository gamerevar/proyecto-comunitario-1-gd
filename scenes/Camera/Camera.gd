extends Camera2D

onready var enabled : bool
export(float,0,1) var correction_value:float #workaround for multi monitor

func _ready():
	enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(delta):
	if enabled : 
		position += _get_cursor_direction()

func _get_cursor_direction() -> Vector2:
	var viewport:Viewport = get_viewport()
	var viewport_size = viewport.size
	var pos_on_viewport:Vector2 = get_viewport().get_mouse_position()
	var min_pos:float = 0
	var max_pos_x:float = viewport_size.x
	var max_pos_y:float = viewport_size.y
	var cursor_direction = Vector2.ZERO
	if pos_on_viewport.x >= min_pos && pos_on_viewport.x <= correction_value:
		cursor_direction.x -=1 # LEFT
	elif pos_on_viewport.x >= max_pos_x - correction_value && pos_on_viewport.x <= max_pos_x :
		cursor_direction.x +=1 # RIGHT
	if pos_on_viewport.y >= min_pos && pos_on_viewport.y <= correction_value:
		cursor_direction.y +=1 #UP
	elif pos_on_viewport.y >= max_pos_y - correction_value && pos_on_viewport.y <= max_pos_y :
		cursor_direction.y -=1 #DOWN
	return cursor_direction
