extends CharacterBody3D

@onready var animation_player = $AnimationPlayer
@onready var camera_3d = $Camera3D
@onready var footstep_audio = $FootstepAudio
@onready var footstep_anim = $FootstepAnim

@onready var sprint_timer = $SprintTimer
@onready var sprint_recover = $SprintRecover

@onready var begin_repair = $UI/CenterContainer/BeginRepair

@export var speed = 3.5
@export var sprintSpeed = 7.0
const JUMP_VELOCITY = 4.5

@export var MOUSE_SENSITIVITY  = 0.5
var ORIGINAL_SENSITIVITY: float
@export var ADS_SLOWDOWN = .5
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Node3D

var flashlightOn:bool = false

var _mouse_input = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3

var isSprinting: bool
var canSprint: bool

func _unhandled_input(event):
	#get mouse input
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _update_camera(delta):
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	_rotation_input = 0.0
	_tilt_input = 0.0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	isSprinting = false
	canSprint = true

func _input(event):
	if Input.is_action_just_pressed("Sprint") and canSprint:
		sprint_timer.start()
		
	if Input.is_action_just_released("Sprint") and canSprint:
		sprint_timer.stop()
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Flashlight") and is_on_floor():
		handleFlashlight()
	
	_update_camera(delta)
	if Input.is_action_pressed("Sprint") and canSprint:
		isSprinting = true
		
	else:
		isSprinting = false
	
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !isSprinting:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		elif isSprinting:
			velocity.x = direction.x * sprintSpeed
			velocity.z = direction.z * sprintSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if direction != Vector3() and is_on_floor():
		if isSprinting and canSprint:
			footstep_anim.play("SprintFootstep")
		else:
			footstep_anim.play("Footstep")
	
	move_and_slide()


func handleFootstepAudio():
	footstep_audio.pitch_scale = randf_range(.8, 1.2)
	footstep_audio.play()

func handleFlashlight():
	if !flashlightOn:
		animation_player.play("lightUp")
		flashlightOn = !flashlightOn
	elif flashlightOn:
		animation_player.play("lightDown")
		flashlightOn = !flashlightOn


func _on_sprint_timer_timeout():
	isSprinting = false
	canSprint = false
	sprint_recover.start()


func _on_sprint_recover_timeout():
	canSprint = true
