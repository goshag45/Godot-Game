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

var direction = Vector3()

# References
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var player = $"."
@onready var viewmodel_camera = $Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera
@onready var fps_rig = $Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera/FPSRig
@onready var smg = $Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera/FPSRig/smg
@onready var aim_ray = $Head/aim_ray

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

	#if Input.is_action_just_pressed("fire"):
	if Input.is_action_pressed("fire"):
		var current_weapon = fps_rig.get_child(0).name
		var target
		if aim_ray.is_colliding():
			target = aim_ray.get_collider()
		_shoot_gun(current_weapon, target)

func _process(_delta):
	# this is cooked
	move_and_slide()

func _shoot_gun(gun, target):
	match gun:
		"revolver":
			pass
		"smg":
			smg._shoot(target)
