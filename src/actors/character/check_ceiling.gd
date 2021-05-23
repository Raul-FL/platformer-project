extends Area2D

func _on_check_ceiling_body_entered(body):
	if body.get_collision_layer_bit(2):
		get_parent().set_collision_mask_bit(2,false)
