extends "res://src/actors/character/character_states/on_ground.gd"

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")

func animation_finished(animation):
	if animation == 'dash_ended' || animation == 'dash_ended_left'\
	 || animation == "stop_run" || animation == "stop_run_left":
		emit_signal('finished', 'idle')

func enter() -> void:
	.enter()
	character_params.velocity.y = 0
	if parent.previous_state.name == "dash":
		if character_params.facing_direction == 1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("dash_ended")
		if character_params.facing_direction == -1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("dash_ended_left")
	elif parent.previous_state.name == "run":
		if character_params.facing_direction == 1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("stop_run")
		if character_params.facing_direction == -1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("stop_run_left")
	else:
		if character_params.facing_direction == 1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("Idle")
		if character_params.facing_direction == -1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("Idle_left")
		if get_input_diretion().y == -1 && character_params.facing_direction == 1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("sub_weapon0")
		if get_input_diretion().y == -1 && character_params.facing_direction == -1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("sub_weapon0_left")

func handle_input():
	return .handle_input()

func update(delta) -> void:
#	if parent.is_in_group("player"):
#		print('idle ', character_params.velocity)
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
	if character_params.facing_direction == 1:
		if character_params.up:
			if character_params.subweapon_mode == 0:
				parent.get_node("AnimatedSprite").get_node("player_animations").play("sub_weapon0")
		if character_params.up_released:
			if character_params.subweapon_mode == 0:
				parent.get_node("AnimatedSprite").get_node("player_animations").play("Idle")
	if character_params.facing_direction == -1:
		if character_params.up:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("sub_weapon0_left")
		if character_params.up_released:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("Idle_left")
	if !is_on_ground():
		emit_signal("finished", "fall")
	if is_instance_valid(get_platforms()):
		if get_platforms().active_hspeed:
			character_params.velocity.y = 0
			if get_platforms().direction == 1:
				character_params.velocity.x = get_platforms().hspeed * 4
			elif get_platforms().direction == -1:
				character_params.velocity.x = -get_platforms().hspeed * 4
			else:
				character_params.velocity = Vector2()
			parent.move_and_slide_with_snap(character_params.velocity, Vector2(0,32),Vector2(0,-1), true,4,2)
	if get_ground():
		parent.move_and_slide(character_params.velocity, Vector2(0,-1))
		if parent.get_floor_velocity().y > 0:
			character_params.velocity.y = parent.get_floor_velocity().y
		if parent.get_floor_velocity().y < 0:
			character_params.velocity.y = -parent.get_floor_velocity().y
		if parent.get_floor_velocity().y == 0:
			character_params.velocity.y = 50
