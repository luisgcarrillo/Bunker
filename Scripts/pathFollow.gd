extends PathFollow3D
@onready var zombie = $Zombie


# Called when the node enters the scene tree for the first time.
var playerSpotted = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !playerSpotted:
		progress += 1 * delta 
	else:
		progress += 0



func _on_zombie_player_spotted():
	playerSpotted = true
	#remove_child(zombie)
