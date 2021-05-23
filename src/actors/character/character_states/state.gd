extends Node
#
onready var parent
onready var character_params
signal finished(next_state_name)
#
func _ready():
	parent = get_parent().get_parent()
	character_params = parent.get_node("CharacterParams")


func enter() -> void:
	return

func exit() -> void:
	return

func handle_input() -> void:
	return

func update(delta) -> void:
	return
