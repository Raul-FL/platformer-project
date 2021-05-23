extends "res://src/actors/character/character_states/on_ground.gd"

var initial_direction : int

func enter() -> void:
	.enter()
	initial_direction = get_input_diretion().x
	if initial_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("run")
	if initial_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("run_left")

func handle_input():
	if character_params.run_released:
		emit_signal("finished", "move")
	if character_params.jump_pressed:
		emit_signal("finished", "jump_run")
	if character_params.up_pressed && character_params.jump:
		emit_signal("finished", "super_jump_run")

func update(delta) -> void:
#	print('run ')
	.update(delta)
	update_x_run()
	if is_on_ground():
		character_params.velocity.y = abs(character_params.velocity.x)
	else:
		character_params.velocity.y = 0
		emit_signal("finished", "fall_run")
	if not get_input_diretion():
		emit_signal('finished', "idle")
	var collision = parent.move_and_collide(character_params.velocity * delta)
	if initial_direction != get_input_diretion().x:
		emit_signal('finished', 'run')
	
	if collision:
		if collision.collider.is_in_group("walls"):
			emit_signal('finished', 'idle')
		character_params.velocity.y = 0
		parent.move_and_slide_with_snap(character_params.velocity, Vector2(0,32), Vector2(0,-1), true)

func exit():
	.exit()
	character_params.run_speed = character_params.run_speed_x
