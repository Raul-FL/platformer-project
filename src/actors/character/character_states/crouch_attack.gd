extends "res://src/actors/character/character_states/motion.gd"

const WHIP = preload("res://assets/objects/items/weapons/melee/whip.tscn")
var remaining_attack_time
var weapon

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")
#	parent.get_node('Whip').get_node("AnimationPlayer").connect('animation_finished', self, "finished_attack")

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
			
func enter() -> void:
	.enter()
	weapon = WHIP.instance()
	parent.add_child(weapon)
	
	if character_params.facing_direction == 1:
		parent.get_node("Whip").show()
		parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack_crouch")
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_attack")
	if character_params.facing_direction == -1:
		parent.get_node("Whip").show()
		parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack_crouch_left")
		parent.get_node("AnimatedSprite").get_node("player_animations").play("crouch_attack_left")

func animation_finished(animation):
	if animation == 'crouch_attack' || animation == 'crouch_attack_left' :
		emit_signal('finished', 'crouch')
	if animation == 'crouch_attack' && !character_params.down_pressed ||\
animation == 'crouch_attack_left' && !character_params.down_pressed:
		emit_signal('finished', 'idle')
	

func exit():
	weapon.queue_free()
#func finished_attack(animation):
#	if animation == 'whip_attack_crouch':
#		parent.get_node("Whip").hide()
#	elif animation == 'whip_attack_crouch_left':
#		parent.get_node("Whip").hide()
