extends Node2D

@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var hit_area = $Path2D/PathFollow2D/HitArea
@onready var repair_area = $Path2D/PathFollow2D/RepairArea
@onready var hit_follow = $Path2D/HitFollow
@onready var repair_follow = $Path2D/RepairFollow
@onready var repair_label = $"../Container/RepairLabel"

var canRepair: bool = false
var repairCount: int = 0
@export var repairsNeeded: int = 3
var repairSuccessful: bool = false
@onready var minigame = $".."
signal generatorMinigameDone
signal turnBeginRepairOff
# Called when the node enters the scene tree for the first time.
func _ready():
	repairRandomize()
	minigame.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if minigame.visible == true:
		repair_label.text = "Repairs Needed: " + str(repairCount) + " / " + str(repairsNeeded)
		hit_follow.progress += 100 * delta

		if canRepair:
			hitCheck()
		repairDoneCheck()


func repairRandomize():
	repair_follow.progress_ratio = randf_range(.15, .95)

func hitCheck():
	if Input.is_action_just_pressed("Repair"):
		if canRepair == true:
			repairCount += 1
		repairRandomize()

func repairDoneCheck():
	if repairCount == repairsNeeded:
		repairSuccessful = true
		minigame.visible = false
		canRepair = false


func minigameReset():
	repairCount = 0

func _on_generator_repair_done():
	minigame.visible = false


func _on_generator_repair_start():
	minigame.visible = true
	turnBeginRepairOff.emit()


func _on_generator_minigame_done():
	minigame.visible = false


func _on_generator_repair_exit():
	if minigame.visible == true:
		minigame.visible = false
	else:
		pass


func _on_repair_area_area_entered(area):
	if area.name == "HitArea":
		canRepair = true


func _on_repair_area_area_exited(area):
	if area.name == "HitArea":
		canRepair = false
