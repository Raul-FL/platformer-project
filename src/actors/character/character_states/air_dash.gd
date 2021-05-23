extends "res://src/actors/character/character_states/in_air.gd"

var inicial_direction setget set_inicial_direction, get_inicial_direction
var inicial_time_left setget set_inicial_time_left, get_inicial_time_left

func _ready():
	parent.get_node("air_dash_timer").connect('timeout', self, "_on_air_dash_timer_timeout")
	inicial_time_left = parent.get_node("air_dash_timer").wait_time

func enter():
	character_params.velocity.y = 0
	inicial_direction = character_params.facing_direction
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("dash")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("dash_left")
	parent.get_node("air_dash_timer").start()

func handle_input():
	if character_params.run_released:
		emit_signal("finished", "fall")
	if character_params.jump_pressed:
		emit_signal("finished", "jump_run")
	if character_params.up_pressed && character_params.jump:
		emit_signal("finished", "super_jump_run")
func update(delta):
#	print('air_dash')
	if inicial_direction == character_params.facing_direction:
		update_x_dash()
	else:
		emit_signal("finished", "fall")
	var collision = parent.move_and_collide(character_params.velocity * delta)
	
	if collision:
		if collision.collider.is_in_group("walls"):
			emit_signal('finished', 'fall')
		character_params.velocity.y = 0
		parent.move_and_slide_with_snap(character_params.velocity, Vector2(0,32), Vector2(0,-1), true)

func _on_air_dash_timer_timeout():
	parent.get_node("air_dash_timer").stop()
	emit_signal('finished', 'fall')

func exit():
	parent.get_node("air_dash_timer").stop()
	parent.get_node("air_dash_timer").wait_time = inicial_time_left

# Getters and setters

func set_inicial_direction(new_value):
	inicial_direction = new_value

func get_inicial_direction():
	return inicial_direction

func set_inicial_time_left(new_value):
	inicial_time_left = new_value

func get_inicial_time_left():
	return inicial_time_left
