extends Sprite

onready var _animation_tree := $AnimationTree
onready var _animation_state : AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")

func play_animation(name: String, direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		_animation_tree.set("parameters/idle/blend_position", direction)
		_animation_tree.set("parameters/" + name + "/blend_position", direction)
	_animation_state.travel(name)
