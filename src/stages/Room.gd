extends Node

export(int) var bound_right
export(int) var bound_bottom

func _ready():
	get_node("Player/Camera2D").limit_right = bound_right
	get_node("Player/Camera2D").limit_bottom = bound_bottom
