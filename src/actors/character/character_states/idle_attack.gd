extends "res://src/actors/character/character_states/motion.gd"

const WHIP = preload("res://assets/objects/items/weapons/melee/whip.tscn")
var remaining_attack_time
var weapon

func _ready():
	parent.get_node('AnimatedSprite').get_node("player_animations").connect('animation_finished', self, "animation_finished")

func enter() -> void:
	.enter()
	if !parent.has_node("Whip"):
		weapon = WHIP.instance()
		parent.add_child(weapon)
	
	if parent.previous_state.name == "air_attack":
		if character_params.facing_direction == 1:
			parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack")
			parent.get_node("Whip").get_node("AnimationPlayer").advance(remaining_attack_time)
			parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_attack")
			parent.get_node("AnimatedSprite").get_node("player_animations").advance(remaining_attack_time)
		if character_params.facing_direction == -1:
			parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack_left")
			parent.get_node("Whip").get_node("AnimationPlayer").advance(remaining_attack_time)
			parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_attack_left")
			parent.get_node("AnimatedSprite").get_node("player_animations").advance(remaining_attack_time)
	else:
		if character_params.facing_direction == 1:
			parent.get_node("Whip").show()
			parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack")
			parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_attack")
		if character_params.facing_direction == -1:
			parent.get_node("Whip").show()
			parent.get_node("Whip").get_node("AnimationPlayer").play("whip_attack_left")
			parent.get_node("AnimatedSprite").get_node("player_animations").play("idle_attack_left")

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

func animation_finished(animation):
	if animation == 'idle_attack' || animation == 'idle_attack_left' :
		emit_signal('finished', 'idle')
