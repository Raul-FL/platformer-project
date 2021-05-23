extends "res://src/actors/character/character_states/in_air.gd"

var came_from_room : = false

func enter():
	if !came_from_room:
		character_params.velocity.y = -character_params.jump_speed
#	came_from_room = false

func handle_input():
	if character_params.jump_released:
		character_params.velocity.y = 0
		emit_signal("finished", "fall")
	.handle_input()

func update(delta):
	came_from_room = false
	.update(delta)
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('jump')
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('jump_left')
#	print('jump ')
	if character_params.velocity.y >= 0:
		emit_signal("finished", "fall")
	owner.get_parent().move_and_slide(character_params.velocity, Vector2(0,-1))
	if parent.is_on_ceiling():
		emit_signal("finished", "fall")

func exit():
	character_params.remaining_y_speed = character_params.velocity.y
