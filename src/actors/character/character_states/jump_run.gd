extends "res://src/actors/character/character_states/in_air.gd"

func enter():
	character_params.velocity.y = -character_params.jump_speed

func handle_input():
	if character_params.jump_released:
		character_params.velocity.y = 0
		emit_signal("finished", "fall_run")

func update(delta):
#	print('jump_run ',get_input_diretion().x)
	.update(delta)
	if character_params.dash_type == 1:
		update_x_run_air()
	if character_params.dash_type == 2:
		update_x_dash_air()
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('jump')
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('jump_left')
	if character_params.velocity.y >= 0:
		emit_signal("finished", "fall_run")
#	print(character_params.velocity.x)
	parent.move_and_slide(character_params.velocity, Vector2(0,-1))
