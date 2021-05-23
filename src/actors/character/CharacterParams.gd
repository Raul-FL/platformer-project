extends Node
class_name CharacterParams

export (int) var subweapon_mode : = 0
export (int) var air_jumps : = 2
export (int) var air_dashes : = 2
export (int) var jump_speed : = 150
export (int) var super_jump_speed : = 300
export (int) var base_speed_x : = 50
export (int) var run_speed_x : = 200
export (int) var dash_speed_x : = 300
export (int) var gravity : = 200
export (int, "no_dash", "run", "multi-dashes", "dash_with_delay") var dash_type : = 1
onready var remaining_jumps : int = air_jumps
onready var remaining_dashes : int = air_dashes
var remaining_y_speed = jump_speed
var speed : int
var run_speed : int
var direction : = 1
var facing_direction : = 1
var velocity : = Vector2()
var left_pressed : = false
var left : = false
var left_released : = false
var right_pressed : = false
var right : = false
var right_released : = false
var up_pressed : = false
var up : = false
var up_released : = false
var down_pressed : = false
var down : = false
var down_released : = false
var run_pressed : = false
var run : = false
var run_released : = false
var jump_pressed : = false
var jump : = false
var jump_released : = false
var fly : = false
var fly_released : = false
var attack : = false
var attack_released : = false
var subweapon1 : = false
var subweapon_axe : = false
var flying_moving_platform : = false
