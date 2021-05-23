extends Node
class_name StateMachineKinematicPLayer

signal state_changed

onready var states_map = {
	"idle" : $states/idle,
	"idle_attack" : $states/idle_attack,
	"idle_guard" : $states/idle_guard,
	"idle_guard_hurt" : $states/idle_guard_hurt,
	"idle_hurt" : $states/idle_hurt,
	"sub_weapon0" : $states/sub_weapon0,
	"sub_weapon1" : $states/sub_weapon1,
	"sub_weapon2" : $states/sub_weapon2,
	"sub_weapon3" : $states/sub_weapon3,
	"sub_weapon_axe" : $states/sub_weapon_axe,
	"jump" : $states/jump,
	"fly_freely" : $states/fly_freely,
	"air_attack" : $states/air_attack,
	"air_subweapon" : $states/air_subweapon,
	"air_subweapon_axe" : $states/air_subweapon_axe,
	"jump_hurt" : $states/jump_hurt,
	"super_jump" : $states/super_jump,
	"super_jump_run" : $states/super_jump_run,
	"air_dash" : $states/air_dash,
	"fall" : $states/fall,
	"move" : $states/move,
	"dash" : $states/dash,
	"dash_ended" : $states/dash_ended,
	"dead" : $states/dead,
	"dive_attack" : $states/dive_attack,
	"run" : $states/run,
	"stop_run" : $states/stop_run,
	"crouch" : $states/crouch,
	"crouch_hurt" : $states/crouch_hurt,
	"crouch_attack" : $states/crouch_attack,
	"crouch_subweapon" : $states/crouch_subweapon,
	"crouch_subweapon_axe" : $states/crouch_subweapon_axe,
	"crouch_guard" : $states/crouch_guard,
	"crouch_guard_hurt" : $states/crouch_guard_hurt,
	"get_up" : $states/get_up,
	"slide_down" : $states/slide_down,
	"guard" : $states/guard,
	"quick_flip" : $states/quick_flip,
	"jump_run" : $states/jump_run,
	"taunt" : $states/taunt,
	"fall_run" : $states/fall_run
	}

export(NodePath) var START_STATE

var states_stack : = []
var current_state = null
var _active : = false setget set_active
var previous_state_room = null
onready var previous_state = states_map["fall"]

func _ready() -> void:
	for child in $states.get_children():
		child.connect("finished", self, "_change_state")
	for child in $states.get_children():
		if child is Motion:
			for i in get_tree().get_nodes_in_group('room_bound'):
				child.connect("check_room_bound", i, "_check_room_bound", [self])
	
	initialize(START_STATE)
	
func initialize(start_state) -> void:
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()
	
func initialize_from_room(chumba_state : Node) -> void:
	set_active(true)
	states_stack = []
	states_stack.push_front(chumba_state)
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
