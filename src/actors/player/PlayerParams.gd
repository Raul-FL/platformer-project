extends "res://src/actors/character/CharacterParams.gd"
class_name PlayerParams

func update_input():
	
	left_pressed = Input.is_action_pressed("ui_left")
	left_released = Input.is_action_just_released("ui_left")
	right_pressed = Input.is_action_pressed("ui_right")
	right_released = Input.is_action_just_released("ui_right")
	up_pressed = Input.is_action_pressed("ui_up")
	up_released = Input.is_action_just_released("ui_up")
	down_pressed = Input.is_action_pressed("ui_down")
	down_released = Input.is_action_just_released("ui_down")
	jump_pressed = Input.is_action_pressed("ui_select")
	jump_released = Input.is_action_just_released("ui_select")
	jump = Input.is_action_just_pressed("ui_select")
	left = Input.is_action_just_pressed("ui_left")
	right = Input.is_action_just_pressed("ui_right")
	up = Input.is_action_just_pressed("ui_up")
	down = Input.is_action_just_pressed("ui_down")
	run = Input.is_action_just_pressed("run")
	run_pressed = Input.is_action_pressed("run")
	run_released = Input.is_action_just_released("run")
	attack = Input.is_action_just_pressed("attack")
	fly = Input.is_action_just_pressed("fly")
	subweapon1 = Input.is_action_just_pressed("sub_weapon")
	subweapon_axe = Input.is_action_just_pressed("subweapon_axe")
