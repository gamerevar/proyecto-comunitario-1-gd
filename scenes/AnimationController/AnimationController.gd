extends Sprite

onready var _animationTree: AnimationTree = $AnimationTree
onready var _animationState: AnimationNodeStateMachinePlayback = _animationTree.get("parameters/playback")

func play_animation(name: String, direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		_animationState.travel("Idle")
	else:
		_animationTree.set("parameters/Idle/blend_position", direction)
		_animationTree.set("parameters/Walk/blend_position", direction)
		_animationState.travel("Walk")
