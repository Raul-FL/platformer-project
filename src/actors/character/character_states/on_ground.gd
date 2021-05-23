extends "res://src/actors/character/character_states/motion.gd"

class_name OnGround

var floor_velocity : = 0

func enter():
	if parent.is_in_group("player"):
		parent.get_node("states").get_node("jump").came_from_room = false
	parent.set_collision_mask_bit(2,true)
	character_params.velocity.y = 100
	parent.get_node("check_ground_left").position.x = -5
	parent.get_node("check_ground_right").position.x = 5

func update(delta):
	parent.move_and_slide(Vector2(0,character_params.velocity.y), Vector2(0,-1))
	if parent.get_floor_velocity().y > 0:
		character_params.velocity.y = parent.get_floor_velocity().y
	if parent.get_floor_velocity().y < 0:
		character_params.velocity.y = -parent.get_floor_velocity().y
	if parent.get_floor_velocity().y == 0:
		character_params.velocity.y = 50
#	if is_instance_valid(get_platforms()):
	if parent.get_floor_velocity().x != 0:
		floor_velocity = parent.get_floor_velocity().x
	elif parent.get_floor_velocity().x == 0:
		floor_velocity = 0
#	if floor_velocity > 0 && character_params.facing_direction == 1:
#		character_params.velocity.x -= floor_velocity
	if floor_velocity > 0 && character_params.facing_direction == -1:
		character_params.velocity.x -= floor_velocity * 1.5
#	if floor_velocity < 0 && character_params.facing_direction == -1:
#		character_params.velocity.x -= floor_velocity
	if floor_velocity < 0 && character_params.facing_direction == 1:
		character_params.velocity.x -= floor_velocity * 1.5
	if is_instance_valid(get_platforms()):
		if get_platforms().active_hspeed:
			if get_platforms().direction == 1:
				character_params.velocity.x += get_platforms().hspeed * 4
			if get_platforms().direction == -1:
				character_params.velocity.x -= get_platforms().hspeed * 4

func handle_input():
	if character_params.jump:
		emit_signal("finished", "jump")
	if character_params.dash_type == 2:
		if character_params.run:
			emit_signal("finished", "dash")
	if character_params.up_pressed && character_params.jump:
		emit_signal("finished", "super_jump")
	if character_params.run_pressed && character_params.up_pressed &&\
	 character_params.jump:
		emit_signal("finished", "super_jump_run")
	if character_params.attack && !character_params.down_pressed:
		emit_signal("finished", "idle_attack")
	if character_params.attack && character_params.up_pressed:
		emit_signal("finished", "sub_weapon1")
	if character_params.subweapon1:
		emit_signal("finished", "sub_weapon2")
	if character_params.subweapon_axe:
		emit_signal("finished", "sub_weapon_axe")
	if character_params.down_pressed:
		emit_signal("finished", "crouch")
	return .handle_input()

func exit():
	parent.get_node("check_ground_left").position.x = -4.5
	parent.get_node("check_ground_right").position.x = 4.5
