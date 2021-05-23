extends "res://src/actors/character/character_states/motion.gd"

func enter():
	print('here')
	parent.get_node("AnimatedSprite").get_node("player_animations").stop()
	
func _ready():
	parent.get_node('hurt_timer').connect('timeout', self, "hurt_timer_timeout")

func hurt_timer_timeout():
	emit_signal("finished", "move")
