extends "res://src/actors/character/character_states/on_ground.gd"

var inicial_direction
var inicial_time_left

func _ready():
	parent.get_node("dash_timer").connect('timeout', self, "_on_dash_timer_timeout")
	inicial_time_left = parent.get_node("dash_timer").wait_time

func enter():
	inicial_direction = character_params.facing_direction
	facing_direction()
	if inicial_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("dash")
	if inicial_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("dash_left")
	parent.get_node("dash_timer").start()

func handle_input():
	if character_params.run_released:
		emit_signal("finished", "idle")
	if character_params.jump_pressed:
		emit_signal("finished", "jump_run")
	if character_params.up_pressed && character_params.jump:
		emit_signal("finished", "super_jump_run")
func update(delta):
#	print('dash')
	if is_on_ground():
		character_params.velocity.y = abs(character_params.velocity.x)
	else:
		parent.get_node("dash_timer").stop()
		character_params.velocity.y = 0
		emit_signal("finished", "fall")
	if inicial_direction == character_params.facing_direction:
		update_x_dash()
	else:
		emit_signal("finished", "idle")
	var collision = parent.move_and_collide(character_params.velocity * delta)
	
	if collision:
		if collision.collider.is_in_group("walls"):
			emit_signal('finished', 'idle')
		character_params.velocity.y = 0
#		var normal = collision.normal
#		if normal.y != -1:
#			character_params.velocity.y = character_params.velocity.x * normal.y *2
		parent.move_and_slide_with_snap(character_params.velocity, Vector2(0,32), Vector2(0,-1), true)
	else:
#		print('here')
		if !is_on_ground():
			emit_signal("finished", "fall")
		

func _on_dash_timer_timeout():
	parent.get_node("dash_timer").stop()
	emit_signal('finished', 'idle')

func exit():
	.exit()
	parent.get_node("dash_timer").stop()
	parent.get_node("dash_timer").wait_time = inicial_time_left
