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
@onready var camera = $Head/firstperson_camera
@onready var player = $"."
@onready var viewmodel_camera = $Head/firstperson_camera/SubViewportContainer/SubViewport/ViewModelCamera
@onready var fps_rig = $Head/firstperson_camera/SubViewportContainer/SubViewport/ViewModelCamera/FPSRig
@onready var smg = $Head/firstperson_camera/SubViewportContainer/SubViewport/ViewModelCamera/FPSRig/smg
@onready var aim_ray = $Head/firstperson_camera/aim_ray
@onready var weapon_viewport = $Head/firstperson_camera/SubViewportContainer/SubViewport
@onready var hitbox = $player_hitbox

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	weapon_viewport.size = DisplayServer.window_get_size()

func _physics_process(delta: float) -> void:
	_escape_mouse()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		# allow for infinite jump
		if Input.is_action_just_pressed("jump"):
			jump()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

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
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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

	var current_weapon = fps_rig.get_child(0)
	var weapon_animation = current_weapon.get_child(2)
	if Input.is_action_just_pressed("reload"):
		weapon_animation.play("reload")
		current_weapon._reload()

	var weapon_name = current_weapon.name
	var target
	var hit_point = aim_ray.get_collision_point()
	if Input.is_action_pressed("fire"):
		if aim_ray.is_colliding():
			target = aim_ray.get_collider()
		_shoot_gun(weapon_name, target, hit_point)
	
	move_and_slide()

func _process(_delta):
	# this is cooked
	pass
	

func _shoot_gun(gun, target, hit_point):
	match gun:
		"smg":
			smg._shoot(target, hit_point)
		"revolver":
			pass

func jump():
	velocity.y = jump_velocity

func _escape_mouse():
	# press escape to show mouse
	if Input.is_action_just_pressed("escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_deathbox_body_entered(body: Node3D) -> void:
	print("test")
	pass # Replace with function body.
