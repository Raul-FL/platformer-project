extends "res://src/actors/character/character_states/on_ground.gd"

func enter() -> void:
	.enter()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("sub_weapon0")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("sub_weapon0_left")

func handle_input():
	if character_params.up_released:
		emit_signal('finished', 'idle')
	return .handle_input()

func update(delta) -> void:
#	print('sub_weapon0 ')
	var input_direction = get_input_diretion()
	if input_direction.x != 0:
		if character_params.dash_type == 1:
			if !check_wall_right() && !check_wall_left():
				if character_params.run_pressed:
					emit_signal("finished", "run")
				else:
					emit_signal("finished", "move")
			elif check_wall_right() && input_direction.x < 0 && character_params.run_pressed:
				emit_signal("finished", "run")
			elif check_wall_right() && input_direction.x < 0:
				emit_signal("finished", "move")
			elif check_wall_left() && input_direction.x > 0 && character_params.run_pressed:
				emit_signal("finished", "run")
			elif check_wall_left() && input_direction.x > 0:
				emit_signal("finished", "move")
		else:
			if !check_wall_right() && !check_wall_left():
					emit_signal("finished", "move")
			elif check_wall_right() && input_direction.x < 0:
				emit_signal("finished", "move")
			elif check_wall_left() && input_direction.x > 0:
				emit_signal("finished", "move")
