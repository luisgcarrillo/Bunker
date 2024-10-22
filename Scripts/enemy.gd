extends CharacterBody3D


@export var speed = 1.0
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var ray_cast_3d = $RayCast3D

@onready var player = get_tree().get_nodes_in_group("Player")
@onready var animation_player = $AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	look_at(player[0].global_transform.origin)
	navigation_agent_3d.set_target_position(player[0].global_transform.origin)
	var nextNavPoint = navigation_agent_3d.get_next_path_position()
	#direction = nextNavPoint - global_transform.origin
	velocity = (nextNavPoint - global_transform.origin).normalized() * speed
	if velocity != Vector3.ZERO:
		animation_player.play("walk",-1,.85)
	move_and_slide()
