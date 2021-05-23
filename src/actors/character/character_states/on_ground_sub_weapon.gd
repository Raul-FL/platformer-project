extends "res://src/actors/character/character_states/motion.gd"

func enter():
	pass

func handle_input():
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("finished", "jump")
	if character_params.dash_type == 2:
		if Input.is_action_just_pressed("run"):
			emit_signal("finished", "dash")
	if Input.is_action_pressed("ui_up") && Input.is_action_just_pressed("ui_select"):
		emit_signal("finished", "super_jump")
	if Input.is_action_pressed('run') && Input.is_action_pressed("ui_up") &&\
	 Input.is_action_just_pressed('ui_select'):
		emit_signal("finished", "super_jump_run")
	if Input.is_action_just_pressed('attack'):
		emit_signal("finished", "sub_weapon1")
	return .handle_input()
