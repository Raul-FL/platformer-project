extends "res://src/actors/character/character_states/on_ground.gd"

var initial_direction : int

func enter() -> void:
	.enter()
	initial_direction = get_input_diretion().x
	if initial_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("walk")
	if initial_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("walk_left")

func handle_input():
	if character_params.dash_type == 1:
		if character_params.run_pressed:
			emit_signal("finished", "run")
	return .handle_input()

func update(delta) -> void:
#	if parent.is_in_group("player"):
#		print('move ', character_params.velocity)
	update_x()
	facing_direction()
	if is_on_ground():
		character_params.velocity.y = abs(character_params.velocity.x)
	else:
		character_params.velocity.y = 0
		emit_signal("finished", "fall")
	if get_input_diretion().x == 0:
		emit_signal('finished', "idle")
	if initial_direction != get_input_diretion().x:
		emit_signal('finished', 'move')
		
	.update(delta)
	var collision = parent.move_and_collide(character_params.velocity * delta)
	
	if collision:
		if collision.collider.is_in_group("walls"):
			emit_signal('finished', 'idle')
		character_params.velocity.y = 0
		var normal = collision.normal
#		if parent.is_in_group("player"):
#			print(character_params.direction)
		if normal.y != -1 && normal.y != 1 && !get_platforms() && character_params.facing_direction == 1\
		:
			character_params.velocity.y = character_params.velocity.x * normal.y *2
		if normal.y != -1 && normal.y != 1 && !get_platforms() && character_params.facing_direction == -1\
		:
			character_params.velocity.y = -(character_params.velocity.x * normal.y *2)
#			if parent.is_in_group("player"):
#				print(normal)
#		character_params.velocity.slide(normal)
#		var remainder = collision.remainder
#		var remaining_movement = remainder.slide(normal)
		parent.move_and_slide_with_snap(character_params.velocity, Vector2(0,10), Vector2(0,-1), true,4,2)
	else:
#		print('here')
		if !is_on_ground():
			emit_signal("finished", "fall")

func exit():
	.exit()
