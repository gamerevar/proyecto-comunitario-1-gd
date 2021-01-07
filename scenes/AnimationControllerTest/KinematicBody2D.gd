extends KinematicBody2D

var last_input = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input = Vector2.ZERO
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_key_pressed(KEY_E): 
		input = Vector2(1, -1)
	elif Input.is_key_pressed(KEY_Q): 
		input = Vector2(-1, -1)
	elif Input.is_key_pressed(KEY_D): 
		input = Vector2(1, 1)
	elif Input.is_key_pressed(KEY_A): 
		input = Vector2(-1, 1)
	
	input = input.normalized()
	
	if input != Vector2.ZERO:
		$CharacterSprite.play_animation("walk", input)
		last_input = input
	elif Input.is_action_pressed("ui_accept"):
		input = last_input
		$CharacterSprite.play_animation("attack", input)
	elif Input.is_action_pressed("ui_cancel"):
		input = last_input
		$CharacterSprite.play_animation("death", input)
	else:
		$CharacterSprite.play_animation("idle", Vector2.ZERO)
	pass
