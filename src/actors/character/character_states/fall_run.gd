extends "res://src/actors/character/character_states/in_air.gd"

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")
	

func animation_finished(animation):
	if animation == 'fall':
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall2")
	if animation == 'fall_left':
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left2")

func enter():
	character_params.velocity.y = 0
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("fall_left")

func handle_input():
	if character_params.jump && character_params.air_jumps > 0:
		character_params.air_jumps -= 1
		emit_signal("finished", "jump_run")
	if character_params.jump && character_params.air_jumps == -1:
		emit_signal("finished", "jump")
	if character_params.jump && character_params.up_pressed && character_params.air_jumps > 0:
		character_params.air_jumps -= 1
		emit_signal("finished", "super_jump_run")
	if character_params.jump && character_params.up_pressed && character_params.air_jumps == -1:
		emit_signal("finished", "super_jump_run")
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
	.update(delta)
	if character_params.dash_type == 1:
		update_x_run_air()
	if character_params.dash_type == 2:
		update_x_dash_air()
#	print("fall ", character_params.velocity.x)
	parent.move_and_slide(character_params.velocity, Vector2(0,-1), true,1)
	if parent.is_on_wall():
		character_params.velocity.x = 0
		parent.move_and_slide(character_params.velocity, Vector2(0,-1), true,4)
	if parent.is_on_floor():
		character_params.air_jumps = character_params.remaining_jumps
		if get_input_diretion().x == 0:
			emit_signal("finished", "idle")
		elif get_input_diretion().x != 0 && !character_params.velocity.x == 0 && character_params.run_pressed:
			emit_signal("finished", "run")
		elif get_input_diretion().x != 0 && !character_params.velocity.x == 0:
			emit_signal("finished", "move")
		elif get_input_diretion().x != 0 && character_params.velocity.x == 0:
			emit_signal("finished", "idle")
#	var collision = parent.move_and_collide(character_params.velocity * delta)
#	if collision:
#		if not is_on_ground() && not is_on_ceiling():
#			var normal = collision.normal
#			var remainder = collision.remainder
#			var remaining_movement = remainder.slide(normal)
#			parent.move_and_collide(remaining_movement)
#		if is_on_ground():
#			character_params.air_jumps = remaining_jumps
#			if get_input_diretion().x != 0:
#				emit_signal("finished", "move")
#			elif get_input_diretion().x == 0:
#				emit_signal("finished", "idle")
