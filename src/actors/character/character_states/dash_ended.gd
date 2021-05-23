extends "res://src/actors/character/character_states/on_ground.gd"

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")

func animation_finished(animation):
	if animation == 'dash_ended' || animation == 'dash_ended_left' :
		emit_signal('finished', 'idle')

func enter() -> void:
	.enter()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("dash_ended")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("dash_ended_left")

func handle_input():
	return .handle_input()

func update(delta) -> void:
#	print('dash_ended ', character_params.remaining_jump_speed)
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
