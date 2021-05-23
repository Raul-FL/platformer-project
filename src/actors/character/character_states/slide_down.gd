extends "res://src/actors/character/character_states/motion.gd"

var inicial_direction
var inicial_time_left

func _ready():
	parent.get_node("slide_timer").connect('timeout', self, "_on_slide_timer_timeout")
	inicial_time_left = parent.get_node("slide_timer").wait_time

func enter():
	inicial_direction = character_params.facing_direction
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("slide_attack")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("slide_attack_left")
	parent.get_node("slide_timer").start()

func handle_input():
	if character_params.run_released && character_params.down_pressed:
		emit_signal("finished", "crouch")
	elif character_params.run_released && !is_on_ceiling():
		emit_signal("finished", "idle")
	elif character_params.run_released && is_on_ceiling():
		emit_signal("finished", "crouch")
func update(delta):
#	print('slide_attack')
	if is_on_ground():
		character_params.velocity.y = abs(character_params.velocity.x)
	else:
		parent.get_node("slide_timer").stop()
		character_params.velocity.y = 0
		emit_signal("finished", "fall")
	if inicial_direction == character_params.facing_direction:
		update_x_dash()
	else:
		emit_signal("finished", "crouch")
	var collision = parent.move_and_collide(character_params.velocity * delta)
	
	if collision:
		if collision.collider.is_in_group("walls"):
			emit_signal('finished', 'crouch')
		character_params.velocity.y = 0
		parent.move_and_slide_with_snap(character_params.velocity, Vector2(0,32), Vector2(0,-1), true)

func _on_slide_timer_timeout():
	parent.get_node("slide_timer").stop()
	emit_signal('finished', 'crouch')
	if !character_params.down_pressed && !is_on_ceiling():
		emit_signal("finished", "idle")

func exit():
	parent.get_node("check_ground_left").position.x = -4.5
	parent.get_node("check_ground_right").position.x = 4.5
	parent.get_node("slide_timer").stop()
	parent.get_node("slide_timer").wait_time = inicial_time_left
