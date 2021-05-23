extends Area2D

export(String, FILE, "*.tscn") var target_stage setget set_target_stage, get_target_stage
export(int, "Horizontal", "Vertical", "Multi") var teleport_position = 0 setget set_teleport_position, get_teleport_position
export(int, "Left", "Right") var warp_point = 1 setget set_warp_point, get_warp_point
export(int) var spectrum setget set_spectrum, get_spectrum

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		Globals.goto_scene_char(target_stage, warp_point, body.current_state, body.position,\
		 body.get_node("CharacterParams").velocity.y,body.get_node("CharacterParams").air_jumps,\
		 body.get_node("CharacterParams").air_dashes, body.get_node("dash_timer").time_left,\
		 body.get_node("CharacterParams").direction, body.get_node("CharacterParams").facing_direction,\
		 body.get_node("air_dash_timer").time_left,\
		 body.get_node("slide_timer").time_left, spectrum)
# setters and getters

func set_spectrum(new_value):
	spectrum = new_value

func get_spectrum():
	return spectrum

func set_target_stage(new_value):
	target_stage = new_value

func get_target_stage():
	return target_stage

func set_teleport_position(new_value):
	teleport_position = new_value

func get_teleport_position():
	return teleport_position

func set_warp_point(new_value):
	warp_point = new_value

func get_warp_point():
	return warp_point
