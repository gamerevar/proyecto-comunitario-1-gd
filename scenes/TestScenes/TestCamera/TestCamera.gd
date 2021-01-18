extends Node2D

onready var _camera = $Camera
onready var _target = $Icon6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if Input.is_action_just_released("ui_select"):
		_camera.set_anchor(_target)
