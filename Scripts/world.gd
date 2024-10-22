extends Node3D

@onready var player = $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_tree().call_group("Enemy", "updateTargetLocation", player.global_position)
