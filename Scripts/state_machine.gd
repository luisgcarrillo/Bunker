extends Node

var states: Dictionary = {}
var currentState : State

@export var initialState: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)

func _process(delta):
	if currentState:
		currentState.Update(delta)

func _physics_process(delta):
	if currentState:
		currentState.PhysicsUpdate(delta)

func on_child_transition(state, newStateName):
	if state != currentState:
		return
	var newState = states.get(newStateName.to_lower())
