extends "res://src/actors/character/character_states/in_air.gd"

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")

func animation_finished(animation):
	if animation == 'fall':
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall2")
	if animation == 'fall_left':
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left2")

func enter():
	parent.get_node("states").get_node("jump").came_from_room = false
#	print(parent.previous_state.name)
	if parent.previous_state.name == 'air_attack' || parent.previous_state.name == 'air_subweapon' || parent.previous_state.name == 'air_subweapon_axe' :
		character_params.velocity.y = character_params.remaining_y_speed
	else:
		character_params.velocity.y = 0
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left")

func handle_input():
	if character_params.jump && character_params.air_jumps > 0:
		character_params.air_jumps -= 1
		emit_signal("finished", "jump")
	if character_params.jump && character_params.air_jumps == -1:
		emit_signal("finished", "jump")
	if character_params.jump && character_params.up_pressed && character_params.air_jumps > 0:
		character_params.air_jumps -= 1
		emit_signal("finished", "super_jump")
	if character_params.jump && character_params.up_pressed && character_params.air_jumps == -1:
		emit_signal("finished", "super_jump")
	.handle_input()
	facing_direction()

	if parent.get_node("AnimatedSprite").get_node("player_animations").current_animation == "fall"\
	&& character_params.facing_direction == -1:
		var animation_point = parent.get_node("AnimatedSprite").get_node("player_animations").current_animation_position
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left")
		parent.get_node("AnimatedSprite").get_node("player_animations").advance(animation_point)
	if parent.get_node("AnimatedSprite").get_node("player_animations").current_animation == "fall_left"\
	&& character_params.facing_direction == 1:
		var animation_point = parent.get_node("AnimatedSprite").get_node("player_animations").current_animation_position
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall")
		parent.get_node("AnimatedSprite").get_node("player_animations").advance(animation_point)
	
	if parent.get_node("AnimatedSprite").get_node("player_animations").current_animation == "fall2"\
	&& character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left2")
	if parent.get_node("AnimatedSprite").get_node("player_animations").current_animation == "fall_left2"\
	&& character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall2")

func update(delta):
#	print('fall ')
	.update(delta)
#	print("fall ", character_params.velocity.x)
	parent.move_and_slide(character_params.velocity, Vector2(0,-1), true,1, 1.2)
	if parent.is_on_wall():
		character_params.velocity.x = 0
		parent.move_and_slide(character_params.velocity, Vector2(0,-1), true,4)
	if parent.is_on_floor():
		character_params.air_jumps = character_params.remaining_jumps
		character_params.air_dashes = character_params.remaining_dashes
		if get_input_diretion().x == 0:
			emit_signal("finished", "idle")
		elif get_input_diretion().x != 0 && !character_params.velocity.x == 0:
			emit_signal("finished", "move")
		elif get_input_diretion().x != 0 && character_params.velocity.x == 0:
			emit_signal("finished", "idle")
		if character_params.down_pressed:
			emit_signal("finished", "crouch")
			

func exit():
	character_params.remaining_y_speed = character_params.velocity.y
