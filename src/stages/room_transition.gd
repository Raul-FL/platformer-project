extends Area2D

var active_bound : = false
var camera_changed : = false

func _on_room_bound_body_entered(body):
	if body.is_in_group('player'):
		active_bound = true
#
func _check_room_bound(body):
	if active_bound:
		var body_extents = body.get_node('CollisionShape2D').shape.extents
		var area_extents = get_node("CollisionShape2D").shape.extents
		var body_rect = Rect2(body.global_position - body_extents, body_extents * 2)
		var area_rect = Rect2(global_position - area_extents, area_extents * 2)
		if area_rect.encloses(body_rect) && !camera_changed:
			print(name)
			get_parent().get_node("Player").get_node("Camera2D").limit_bottom = area_extents.y * 2 + area_rect.position.y
			get_parent().get_node("Player").get_node("Camera2D").limit_top = area_rect.position.y
			get_parent().get_node("Player").get_node("Camera2D").limit_right = area_extents.x * 2 + area_rect.position.x
			get_parent().get_node("Player").get_node("Camera2D").limit_left = area_rect.position.x
#			get_parent().get_node("Player/Camera2D").global_position = global_position
			camera_changed = true
		elif !area_rect.encloses(body_rect):
			print("body is NOT fully inside area!")

func _on_room_bound_body_exited(body):
	active_bound = false
	camera_changed = false
