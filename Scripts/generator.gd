extends Node3D

signal repairStart
signal repairDone
signal repairCheck
signal repairExit

@export var generatorData: Generator_Resource
@onready var repair_area = $RepairArea

@onready var player = get_tree().get_nodes_in_group("Player")
@onready var generators = get_tree().get_nodes_in_group("Generator")

@onready var begin_repair = $UI/CenterContainer/BeginRepair
@onready var minigame = preload("res://Scenes/minigame.tscn")
var currentGenerator
var canBeRepaired: bool = false
var isRepaired: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.generatorData.repairsNeeded = randi_range(3,5)
	#initialize()
	
	#print(generatorData.generatorNum)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact") and canBeRepaired:
		beginRepair()
	else:
		pass
	

func repairAreaCheck(area):
	if area.name == "RepairCheck":
		canBeRepaired = true
	else:
		canBeRepaired = false

func beginRepair():
	repairStart.emit()


func _on_repair_area_body_entered(body):
	if body.is_in_group("Player"):
		canBeRepaired = true
		var currentGenNum = generatorData.generatorNum
		var currentGenerator = generators[currentGenNum]
		print(str(currentGenerator))
		repairCheck.emit()
		begin_repair.visible = true
		#else:
			#begin_repair.visible = false
	else:
		canBeRepaired = false


func _on_repair_area_body_exited(body):
	if body.is_in_group("Player"):
		canBeRepaired = false
		begin_repair.visible = false
	else:
		pass

func _on_minigame_1_generator_minigame_done():
	canBeRepaired = false
	currentGenerator.isRepaired = true
	print(str(currentGenerator.generatorData))
	

func _on_minigame_1_turn_begin_repair_off():
	begin_repair.visible = false
