extends "res://src/actors/character/character_states/motion.gd"

func handle_input():
	if character_params.facing_direction == 1 && character_params.left:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_left")
		parent.get_node("AnimatedSprite").get_node("player_animations").advance(0.3)
	elif character_params.facing_direction == -1 && character_params.right:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch")
		parent.get_node("AnimatedSprite").get_node("player_animations").advance(0.3)
	facing_direction()
	if character_params.down_released && !is_on_ceiling():
		emit_signal("finished", "idle")
	if character_params.attack:
		emit_signal("finished", "crouch_attack")
	if character_params.subweapon1:
		emit_signal("finished", "crouch_subweapon")
	if character_params.subweapon_axe:
		emit_signal("finished", "crouch_subweapon_axe")
	if character_params.run:
		emit_signal("finished", "slide_down")
	if character_params.jump && (get_ground() || get_platforms()):
		parent.set_collision_mask_bit(1,false)
		emit_signal("finished", "fall")

func update(delta):
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

func enter() -> void:
#	parent.get_node("Whip").hide()
	.enter()
	if parent.previous_state.name == "crouch_attack":
		if character_params.facing_direction == 1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch")
			parent.get_node("AnimatedSprite").get_node("player_animations").advance(0.4)
		elif character_params.facing_direction == -1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_left")
			parent.get_node("AnimatedSprite").get_node("player_animations").advance(0.4)
	else:
		if character_params.facing_direction == 1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch")
		if character_params.facing_direction == -1:
			parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_left")
