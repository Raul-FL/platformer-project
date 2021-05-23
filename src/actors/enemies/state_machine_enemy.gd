extends Node

signal state_changed

onready var states_map = {
	"idle" : $states/idle,
	"idle_attack" : $states/idle_attack,
	"idle_hurt" : $states/idle_hurt,
	"jump" : $states/jump,
	"move" : $states/move,
	"move_water" : $states/move_water,
	"idle_water" : $states/idle_water,
	}

export(NodePath) var START_STATE

var states_stack : = []
var current_state = null
var _active : = false setget set_active
onready var previous_state = states_map["idle"]

func _ready() -> void:
	for child in $states.get_children():
		child.connect("finished", self, "_change_state")
	initialize(START_STATE)
	
func initialize(start_state) -> void:
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()

func set_active(value : bool) -> void:
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null

func _physics_process(delta):
	$CharacterParams.update_input()
	current_state.handle_input()
	current_state.update(delta)
#	print(previous_state.name)

func _change_state(state_name : String) -> void:
	previous_state = current_state
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
	
	if state_name != "previous":
		current_state.enter()
