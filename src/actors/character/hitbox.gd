extends Area2D

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		if get_parent().get_node("invulnerability_timer").is_stopped() && get_parent().get_node("stun_timer").is_stopped():
			if get_parent().current_state.is_in_group('stand'):
				get_parent().get_node("states/idle").emit_signal("finished", "idle_hurt")
			if get_parent().current_state.is_in_group('in_air'):
				get_parent().get_node("states/idle").emit_signal("finished", "jump_hurt")
			if get_parent().current_state.is_in_group('crouch'):
				get_parent().get_node("states/idle").emit_signal("finished", "crouch_hurt")
			get_parent().get_node("stun_timer").start()
			PlayerGlobals.hp -= 1
			get_parent().get_parent().get_node("CanvasLayer").get_node("MarginContainer").get_node("LifeBar").value -= 1

func _on_stun_timer_timeout():
	get_parent().get_node("stun_timer").stop()


func _on_invulnerability_timer_timeout():
	get_parent().get_node("invulnerability_timer").stop()
