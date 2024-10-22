extends Node3D
@export var _generator_resources: Array[Generator_Resource]
@onready var begin_repair = $Generator/UI/CenterContainer/BeginRepair

# Called when the node enters the scene tree for the first time.
func _ready():
	Initialize(_generator_resources)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func Initialize(_generator_resources: Array):
	for Generator in _generator_resources:
		Generator.isRepaired = false
		Generator.currentRepairs = 0
		Generator.repairsNeeded = randi_range(3,5)


func _on_minigame_1_turn_begin_repair_off():
	begin_repair.visible = false
