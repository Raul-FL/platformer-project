extends "res://src/actors/character/character_states/motion.gd"

class_name InAir

func enter():
	pass

func handle_input():
	if character_params.attack:
		emit_signal('finished', 'air_attack')
	if character_params.subweapon1:
		emit_signal('finished', 'air_subweapon')
	if character_params.subweapon_axe:
		emit_signal('finished', 'air_subweapon_axe')
	if character_params.run && character_params.air_dashes > 0:
		character_params.air_dashes -= 1
		emit_signal('finished', 'air_dash')
	elif character_params.run && character_params.air_dashes == -1:
		emit_signal('finished', 'air_dash')
	if character_params.fly:
		emit_signal('finished', 'fly_freely')
	.handle_input()

func update(delta):
	update_gravity(delta)
	update_x()
	if is_on_ceiling():
		parent.set_collision_mask_bit(2, false)
	if is_on_ground() && !is_on_ceiling():
		parent.set_collision_mask_bit(2, true)
	if !is_on_ceiling() && !is_on_ground():
		parent.set_collision_mask_bit(2, false)
	.update(delta)

func update_x_run_air():
	character_params.velocity.x = character_params.run_speed * get_input_diretion().x

func update_x_dash_air():
	character_params.velocity.x = character_params.dash_speed_x * get_input_diretion().x
