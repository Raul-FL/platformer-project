extends Node

class_name EnemyStats

export (int) var max_hp : int
export (int) var hp : int
export (int) var max_mp : int
export (int) var mp : int
export (int) var max_sp : int
export (int) var sp : int
export (int) var level : int
export (int) var xp : int
export (int) var atk : int
export (int) var def : int
export (int) var sp_atk : int
export (int) var sp_def : int

func hurt(damage : int, delay_timer : int, status : int):
#	print('here')
	hp -= damage
#	print('here')
	get_parent().get_node("states/move").emit_signal("finished", "idle_hurt")
	get_parent().get_node("walk_timer").paused = true
	get_parent().get_node("hurt_timer").start()

func _on_hurt_timer_timeout():
	get_parent().get_node("hurt_timer").stop()
	get_parent().get_node("walk_timer").paused = false
