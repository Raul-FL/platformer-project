extends "res://src/actors/character/character_states/in_air.gd"

func enter():
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall2")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left2")

func handle_input():
	if character_params.fly:
		emit_signal("finished", "fall")

func update(delta):
#	print("fly_freely")
	var motion = Vector2()
	if character_params.up_pressed:
		motion += Vector2(0, -1)
	if character_params.down_pressed:
		motion += Vector2(0, 1)
	if character_params.left_pressed:
		motion += Vector2(-1, 0)
	if character_params.right_pressed:
		motion += Vector2(1, 0)
	
	parent.move_and_slide(motion * character_params.base_speed_x)
	
	if parent.get_node("AnimatedSprite").get_node("player_animations").current_animation == "fall2"\
	&& character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left2")
	if parent.get_node("AnimatedSprite").get_node("player_animations").current_animation == "fall_left2"\
	&& character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall2")
