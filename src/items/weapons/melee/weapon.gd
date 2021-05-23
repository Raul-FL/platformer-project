extends Area2D

export(int) var attack = 1
var did_damage = false

func _on_Whip_body_entered(body):
	if body.is_in_group("enemy"):
		if body.get_node("CharacterStats").hp > 0:
			if !did_damage:
				body.get_node("CharacterStats").hurt(attack,0.2,0)
				if $AnimationPlayer.is_playing():
					did_damage = true
		else:
			body.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "whip_attack":
		did_damage = false
	queue_free()
