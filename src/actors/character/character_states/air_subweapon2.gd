extends "res://src/actors/character/character_states/in_air.gd"

const BULLET = preload("res://assets/objects/items/weapons/projectile/bullet.tscn")
var bullet
var remaining_attack_time setget set_remaining_attack_time, get_remaining_attack_time

#func _ready():
#	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")

func animation_finished(animation):
	if animation == 'jump_attack' || animation == 'jump_attack_left' :
		if character_params.velocity.y >= 0:
			emit_signal("finished", "fall")
		else:
			emit_signal("finished", "jump")
func enter():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")
	character_params.velocity.y = character_params.remaining_y_speed
	parent.get_node('AnimatedSprite').connect('frame_changed', self, "frame_changed")	
	
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('jump_attack')
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play('jump_attack_left')

func handle_input():
	if character_params.jump_released:
		character_params.velocity.y = 0

func update(delta):
	.update(delta)
#	print('air_attack ')
	parent.move_and_slide(character_params.velocity, Vector2(0,-1))
	if parent.is_on_wall():
		character_params.velocity.x = 0
		parent.move_and_slide(character_params.velocity, Vector2(0,-1), true,4)
	if parent.is_on_floor():
		character_params.air_jumps = character_params.remaining_jumps
		character_params.air_dashes = character_params.remaining_dashes
		if get_input_diretion().x == 0:
			emit_signal("finished", "idle")
		elif get_input_diretion().x != 0 && !character_params.velocity.x == 0:
			emit_signal("finished", "move")
		elif get_input_diretion().x != 0 && character_params.velocity.x == 0:
			emit_signal("finished", "idle")
		if character_params.down_pressed:
			emit_signal("finished", "crouch")
		


func frame_changed():
	if parent.get_node('AnimatedSprite').frame == 3:
		bullet = BULLET.instance()
		if character_params.facing_direction == 1:
			bullet.global_position = parent.get_node('pivots').get_node('bullet_pivot').global_position
		elif character_params.facing_direction == -1:
			bullet.global_position = parent.get_node('pivots').get_node('bullet_pivot').global_position
			bullet.global_position.x -= (bullet.global_position.x - parent.global_position.x)*2
			bullet.directionx = -1
		if character_params.right_pressed && character_params.up_pressed:
			bullet.directionx = 1
			bullet.directiony = -1
		if character_params.right_pressed && character_params.down_pressed:
			bullet.directionx = 1
			bullet.directiony = 1
		elif character_params.left_pressed && character_params.up_pressed:
			bullet.directionx = -1
			bullet.directiony = -1
		elif character_params.left_pressed && character_params.down_pressed:
			bullet.directionx = -1
			bullet.directiony = 1
		elif character_params.up_pressed:
			bullet.directionx = 0
			bullet.directiony = -1
		elif character_params.down_pressed:
			bullet.directionx = 0
			bullet.directiony = 1
		get_tree().current_scene.add_child(bullet)

func exit():
	parent.get_node('AnimatedSprite').get_node("player_animations").disconnect('animation_finished', self, "animation_finished")
	character_params.remaining_y_speed = character_params.velocity.y
	parent.get_node('AnimatedSprite').disconnect('frame_changed', self, "frame_changed")

# Setters and getters

func set_remaining_attack_time(new_value):
	remaining_attack_time - new_value

func get_remaining_attack_time():
	return remaining_attack_time
