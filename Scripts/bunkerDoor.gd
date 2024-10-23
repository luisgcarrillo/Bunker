extends Node3D

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var area_3d = $Area3D
var canOpen: bool = false
var doorOpen: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	canOpen = false
	doorOpen = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact") and canOpen:
		animation_player.play("Default Take")
		timer.start()

func _on_area_3d_body_entered(body):
	canOpen = true


func _on_area_3d_body_exited(body):
	canOpen = false


func _on_timer_timeout():
	animation_player.pause()
	doorOpen = true
	canOpen = false
