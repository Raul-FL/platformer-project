extends "res://src/actors/character/character_states/motion.gd"

func enter():
	print('here')
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_hurt")
	elif character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_hurt_left")

func _ready():
	parent.get_node('stun_timer').connect('timeout', self, "stun_timer_timeout")

func stun_timer_timeout():
	emit_signal("finished", "fall")
	parent.get_node('invulnerability_timer').start()
