extends Node

var current_scene = null
var previous_scene = null
#onready var player_variables = get_node('/root/PlayerVariables')

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func _finished_load_scene(path, warp_position, body_state, char_position, body_velocity_y,\
 body_remaining_jumps, body_remaining_dashes, body_dash_time_left, current_scene, direction, facing_direction, body_air_dash_time_left, body_slide_time_left, spectrum):
#	print('loaded_scene')
	var player = get_tree().get_nodes_in_group("player").front()
	player.get_node("CharacterParams").velocity.y = body_velocity_y
	player.get_node("CharacterParams").air_jumps = body_remaining_jumps
	player.get_node("CharacterParams").air_dashes = body_remaining_dashes
	player.get_node("CharacterParams").direction = direction
	player.get_node("CharacterParams").facing_direction = facing_direction
	player.get_node("states").get_node("jump").came_from_room = true
#	player.get_node("states").get_node("dash").inicial_direction = facing_direction
	if body_state == "dash" && body_dash_time_left > 0:
		player.get_node("dash_timer").wait_time = body_dash_time_left
	if body_state == "air_dash" && body_air_dash_time_left > 0:
		player.get_node("air_dash_timer").wait_time = body_air_dash_time_left
	if body_state == "slide_down" && body_slide_time_left > 0:
		player.get_node("slide_timer").wait_time = body_slide_time_left
	player.initialize_from_room(player.get_node("states").get_node(body_state))
	if warp_position == 1:
		player.position = Vector2(8,char_position.y)
	if warp_position == 0:
		player.position = Vector2(current_scene.bound_right -8,char_position.y)
	player.position.y += spectrum
#	print("cadkasjkldjsadkjfalksdjfklasdjfsaçfjasdkjflskdaçjfdklsj ", player.get_node("CharacterParams").facing_direction)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func goto_scene_char(path, warp_position, body_state, char_position, body_velocity_y,\
 body_remaining_jumps, body_remaining_dashes, body_dash_time_left, direction, facing_direction, body_air_dash_time_left, body_slide_time_left, spectrum):
	call_deferred("_deferred_goto_scene_char",path, warp_position, body_state.name, char_position,\
	body_velocity_y, body_remaining_jumps, body_remaining_dashes, body_dash_time_left, direction, facing_direction, body_air_dash_time_left, body_slide_time_left, spectrum)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func _deferred_goto_scene_char(path, warp_position, body_state, char_position, body_velocity_y,\
 body_remaining_jumps, body_remaining_dashes, body_dash_time_left, direction, facing_direction, body_air_dash_time_left, body_slide_time_left, spectrum):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	_finished_load_scene(path, warp_position, body_state, char_position, body_velocity_y,\
 body_remaining_jumps, body_remaining_dashes, body_dash_time_left, current_scene, direction, facing_direction, body_air_dash_time_left, body_slide_time_left, spectrum)
