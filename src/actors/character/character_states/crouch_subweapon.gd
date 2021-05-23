extends "res://src/actors/character/character_states/motion.gd"

const BULLET = preload("res://assets/objects/items/weapons/projectile/bullet.tscn")
var remaining_attack_time
var bullet

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")
#	parent.get_node('Whip').get_node("AnimationPlayer").connect('animation_finished', self, "finished_attack")

func enter() -> void:
	.enter()
	parent.get_node('AnimatedSprite').connect('frame_changed', self, "frame_changed")
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_attack")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_attack_left")

func animation_finished(animation):
	if animation == 'crouch_attack' || animation == 'crouch_attack_left' :
		emit_signal('finished', 'crouch')
	if animation == 'crouch_attack' && !character_params.down_pressed ||\
animation == 'crouch_attack_left' && !character_params.down_pressed:
		emit_signal('finished', 'idle')
	

func exit():
	parent.get_node('AnimatedSprite').disconnect('frame_changed', self, "frame_changed")
#func finished_attack(animation):
#	if animation == 'whip_attack_crouch':
#		parent.get_node("Whip").hide()
#	elif animation == 'whip_attack_crouch_left':
#		parent.get_node("Whip").hide()


func frame_changed():
	if parent.get_node('AnimatedSprite').frame == 3:
		bullet = BULLET.instance()
		parent.add_child(bullet)
		if character_params.facing_direction == 1:
			bullet.position = parent.get_node('pivots').get_node('bullet_pivot_crouch').position
		elif character_params.facing_direction == -1:
			bullet.position = Vector2(-parent.get_node('pivots').get_node('bullet_pivot_crouch').position.x, parent.get_node('pivots').get_node('bullet_pivot_crouch').position.y)
			bullet.directionx = -1
		if character_params.right_pressed && character_params.down_pressed:
			bullet.directionx = 1
			bullet.directiony = 1
		if character_params.left_pressed && character_params.down_pressed:
			bullet.directionx = -1
			bullet.directiony = 1
#		elif character_params.right_pressed && character_params.down_pressed:
#			bullet.directionx = 1
#			bullet.directiony = 1
#		elif character_params.up_pressed:
#			bullet.directionx = 0
#			bullet.directiony = -1
#		else:
#		bullet.directionx = 1
