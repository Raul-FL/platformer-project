extends "res://src/actors/character/character_states/motion.gd"

const BULLET = preload("res://assets/objects/items/weapons/projectile/ballistic.tscn")
var bullet

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")

func enter() -> void:
	.enter()
	parent.get_node('AnimatedSprite').connect('frame_changed', self, "frame_changed")
	if character_params.facing_direction == 1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_attack")
	if character_params.facing_direction == -1:
		parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_attack_left")

func animation_finished(animation):
	if animation == 'sub_weapon2' || animation == 'sub_weapon2_left' :
		emit_signal('finished', 'idle')

func update(delta):
	if is_instance_valid(get_platforms()):
		if get_platforms().active_hspeed:
			character_params.velocity.y = 0
			if get_platforms().direction == 1:
				character_params.velocity.x = get_platforms().hspeed * 4
			elif get_platforms().direction == -1:
				character_params.velocity.x = -get_platforms().hspeed * 4
			else:
				character_params.velocity = Vector2()
			parent.move_and_slide_with_snap(character_params.velocity, Vector2(0,32),Vector2(0,-1), true,4,2)
	if get_ground():
		parent.move_and_slide(character_params.velocity, Vector2(0,-1))
		if parent.get_floor_velocity().y > 0:
			character_params.velocity.y = parent.get_floor_velocity().y
		if parent.get_floor_velocity().y < 0:
			character_params.velocity.y = -parent.get_floor_velocity().y
		if parent.get_floor_velocity().y == 0:
			character_params.velocity.y = 50
			
func frame_changed():
	if parent.get_node('AnimatedSprite').frame == 3:
		bullet = BULLET.instance()
		bullet.speed = 150
		if character_params.facing_direction == 1:
			bullet.global_position = parent.get_node('pivots').get_node('bullet_pivot').global_position
			bullet.directiony = -50
			bullet.speed = 100
		elif character_params.facing_direction == -1:
			bullet.global_position = parent.get_node('pivots').get_node('bullet_pivot').global_position
			bullet.global_position.x -= (bullet.global_position.x - parent.global_position.x)*2
			bullet.directionx = -1
			bullet.directiony = -50
			bullet.speed = 100
		if character_params.right_pressed && character_params.up_pressed:
			bullet.directionx = 1
			bullet.directiony = -200
			bullet.speed = 100
		elif character_params.left_pressed && character_params.up_pressed:
			bullet.global_position = parent.get_node('pivots').get_node('bullet_pivot').global_position
			bullet.global_position.x -= (bullet.global_position.x - parent.global_position.x)*2
			bullet.directionx = -1
			bullet.directiony = -200
			bullet.speed = 100
		elif character_params.up_pressed:
			bullet.speed = 40
			bullet.directiony = -200
#		else:
#			bullet.directionx = 
		get_tree().current_scene.add_child(bullet)

func exit():
	parent.get_node('AnimatedSprite').disconnect('frame_changed', self, "frame_changed")
