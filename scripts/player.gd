extends CharacterBody3D

# VARIABLES
@export_category("Player Stats")
@export var SENSITIVITY = 0.0013
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var base_fov = 90
@export var fov_scale = 1.5
@export var gravity = 9.8
@export var ammo_revolver = 6
@export var speed = walk_speed

#head bob stuff
const BOB_FREQ = 2.0
const BOB_AMP = 0.04
var t_bob = 0.0

var direction = Vector3()

# References
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var player = $"."
@onready var player_walk_animation = $Sketchfab_model/hero_fbx/RootNode/rig/Object_4/Skeleton3D/AnimationPlayer
@onready var viewmodel_camera = $Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera
@onready var revolver = $Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera/FPSRig/Revolver


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/Camera3D/SubViewportContainer/SubViewport.size = DisplayServer.window_get_size()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# press escape to show mouse
	if Input.is_action_just_pressed("escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Align viewmodel rig camera with head camera
	viewmodel_camera.global_transform = camera.global_transform

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
		var velocity_clamped = clamp(velocity.length(), 0.5, sprint_speed * 2)
		var target_fov = base_fov + fov_scale * velocity_clamped
		camera.fov = lerp(camera.fov, target_fov, delta * 2.0)
	else:
		var target_fov = 90.0
		camera.fov = lerp(camera.fov, target_fov, delta * 2.0)
		speed = walk_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 4.0)

	# head bobbin
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	if Input.is_action_just_pressed("fire"):
		_shoot_gun("Revolver")

func _process(_delta):
	# this is cooked
	move_and_slide()

func _headbob(time):
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = sin(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func _shoot_gun(gun):
	match gun:
		"Revolver":
			revolver._shoot()
