extends "res://src/actors/character/character_states/state.gd"

class_name Motion

signal check_room_bound

func get_platforms():
	if parent.get_node("check_ground_left").is_colliding()\
	 || parent.get_node("check_ground_right").is_colliding():
		var collider_ground_left = parent.get_node("check_ground_left").get_collider()
		var collider_ground_right = parent.get_node("check_ground_right").get_collider()
		if is_instance_valid(collider_ground_left):
			if collider_ground_left.is_in_group("flying_platforms"):
				return collider_ground_left
		if is_instance_valid(collider_ground_right):
			if collider_ground_right.is_in_group("flying_platforms"):
				return collider_ground_right
	return null

func get_ground() -> bool:
	if parent.get_node("check_ground_left").is_colliding()\
	 || parent.get_node("check_ground_right").is_colliding():
		var collider_ground_left = parent.get_node("check_ground_left").get_collider()
		var collider_ground_right = parent.get_node("check_ground_right").get_collider()
		if is_instance_valid(collider_ground_left):
			if collider_ground_left.is_in_group("flying_moving_platforms"):
				return true
		if is_instance_valid(collider_ground_right):
			if collider_ground_right.is_in_group("flying_moving_platforms"):
				return true
	return false

func is_on_ground() -> bool:
	if parent.get_node("check_ground_left").is_colliding() || parent.get_node("check_ground_right").is_colliding():
		return true
	return false

func is_on_ceiling() -> bool:
	if parent.get_node("check_ceiling_left").is_colliding() || parent.get_node("check_ceiling_right").is_colliding():
		return true
	return false

func check_wall_right() -> bool:
	if parent.get_node("check_wall_uright").is_colliding() ||\
	 parent.get_node("check_wall_muright").is_colliding() ||\
	 parent.get_node("check_wall_mdright").is_colliding() ||\
	 parent.get_node("check_wall_dright").is_colliding():
		return true
	return false

func check_wall_left() -> bool:
	if parent.get_node("check_wall_uleft").is_colliding() ||\
	 parent.get_node("check_wall_muleft").is_colliding() ||\
	 parent.get_node("check_wall_mdleft").is_colliding() ||\
	 parent.get_node("check_wall_dleft").is_colliding():
		return true
	return false

func update_gravity(delta):
	character_params.velocity.y += character_params.gravity * delta

func update_x():
	emit_signal("check_room_bound")
	character_params.velocity.x = character_params.base_speed_x * get_input_diretion().x

func update_x_run():
	character_params.velocity.x = character_params.run_speed_x * get_input_diretion().x

func update_x_dash():
	character_params.velocity.x = character_params.dash_speed_x * character_params.facing_direction

func handle_input() -> void:
	facing_direction()

func get_input_diretion() -> Vector2:
	var input_direction = Vector2()
	
	input_direction.x = int(character_params.right_pressed) - int(character_params.left_pressed)
	input_direction.y = int(character_params.down_pressed) - int(character_params.up_pressed)
	return input_direction

func facing_direction():
	if get_input_diretion().x == 1:
		character_params.facing_direction = 1
	elif get_input_diretion().x == -1:
		character_params.facing_direction = -1
		
