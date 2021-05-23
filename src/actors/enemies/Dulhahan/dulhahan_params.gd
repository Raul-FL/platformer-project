extends "res://src/actors/character/CharacterParams.gd"

func _ready():
	left_pressed = true

func update_input():
	pass

func _on_walk_timer_timeout():
	right_pressed = !right_pressed
	left_pressed = !left_pressed
	get_parent().get_node("walk_timer").stop()
	get_parent().get_node("walk_timer").start()

func _on_alarm_area_body_entered(body):
	if body.is_in_group("player"):
		print(body.position - get_parent().position)
