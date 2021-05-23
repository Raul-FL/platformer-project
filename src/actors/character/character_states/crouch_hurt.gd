extends "res://src/actors/character/character_states/motion.gd"

func enter():
	print('here')
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_hurt")
	elif character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_hurt_left")

func _ready():
	parent.get_node('stun_timer').connect('timeout', self, "stun_timer_timeout")

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
func stun_timer_timeout():
	if character_params.down_pressed:
		emit_signal("finished", "crouch")
	else:
		emit_signal("finished", "idle")
	parent.get_node('invulnerability_timer').start()
