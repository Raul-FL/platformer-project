extends "res://src/actors/character/character_states/in_air.gd"

const WHIP = preload("res://assets/objects/items/weapons/melee/whip.tscn")
var remaining_attack_time setget set_remaining_attack_time, get_remaining_attack_time
var weapon setget set_weapon, get_weapon

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
	
	weapon = WHIP.instance()
	parent.add_child(weapon)
	
	facing_direction()
	if character_params.facing_direction == 1:
		parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack_jump")
		parent.get_node("AnimatedSprite").get_node("player_animations").play('jump_attack')
	if character_params.facing_direction == -1:
		parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack_jump_left")
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
#		print('beepboop')
		character_params.air_jumps = character_params.remaining_jumps
		if get_input_diretion().x == 0:
			parent.get_node("states").get_node("idle_attack").remaining_attack_time = parent.get_node("AnimatedSprite").get_node("player_animations").current_animation_position
			emit_signal("finished", "idle_attack")
		elif get_input_diretion().x != 0 && !character_params.velocity.x == 0:
			parent.get_node("states").get_node("idle_attack").remaining_attack_time = parent.get_node("AnimatedSprite").get_node("player_animations").current_animation_position
			emit_signal("finished", "idle_attack")
		elif get_input_diretion().x != 0 && character_params.velocity.x == 0:
			parent.get_node("states").get_node("idle_attack").remaining_attack_time = parent.get_node("AnimatedSprite").get_node("player_animations").current_animation_position
			emit_signal("finished", "idle_attack")
		
func exit():
	parent.get_node('AnimatedSprite').get_node("player_animations").disconnect('animation_finished', self, "animation_finished")
	character_params.remaining_y_speed = character_params.velocity.y

# Setters and getters

func set_weapon(new_value):
	weapon = new_value

func get_weapon():
	return weapon

func set_remaining_attack_time(new_value):
	remaining_attack_time - new_value

func get_remaining_attack_time():
	return remaining_attack_time
