extends "res://src/actors/character/character_states/in_air.gd"

func enter():
	character_params.velocity.y = -character_params.super_jump_speed

func handle_input():
	if character_params.jump_released:
#		print('hereererere')
		character_params.velocity.y = 0
		emit_signal("finished", "fall")

func update(delta):
	.update(delta)
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('super_jump')
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('super_jump_left')
	print('super_jump ')
	if character_params.velocity.y >= 0:
		emit_signal("finished", "fall")
	owner.get_parent().move_and_slide(character_params.velocity, Vector2(0,-1))
	if parent.is_on_ceiling():
		emit_signal("finished", "fall")
