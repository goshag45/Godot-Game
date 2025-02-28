extends CharacterBody3D

# VARIABLES
@export_category("Player Stats")
@export var sensitivity_input = 1.3
#weird calc - stupid
var SENSITIVITY = sensitivity_input/1000
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var base_fov = 90
@export var fov_scale = 1.5
@export var gravity = 9.8
@export var ammo_revolver = 6
@export var speed = walk_speed
@export var health = 100

# References
@onready var head = $Head
@onready var camera = $Head/firstperson_camera
@onready var player = $"."
@onready var viewmodel_camera = $Head/firstperson_camera/sub_viewport_container/sub_viewport/ViewModelCamera
@onready var fps_rig = $Head/firstperson_camera/sub_viewport_container/sub_viewport/ViewModelCamera/FPSRig
@onready var aim_ray = $Head/firstperson_camera/aim_ray
@onready var weapon_viewport = $Head/firstperson_camera/sub_viewport_container/sub_viewport
@onready var hitbox = $player_hitbox
@onready var audio_component = $audio_component
# WEAPONS
@onready var smg = $Head/firstperson_camera/sub_viewport_container/sub_viewport/ViewModelCamera/FPSRig/smg
@onready var revolver = $Head/firstperson_camera/sub_viewport_container/sub_viewport/ViewModelCamera/FPSRig/revolver

@onready var current_weapon = smg
var direction = Vector3()
var jump_sounds = ["jump1", "jump2", "jump3"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	weapon_viewport.size = DisplayServer.window_get_size()
	current_weapon.show()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		# allow for infinite jump
		if Input.is_action_just_pressed("jump"):
			audio_component._play_random_sfx(jump_sounds, 6)
			jump()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		audio_component._play_random_sfx(jump_sounds, 6)

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

	if (Input.is_action_just_pressed("num1")):
		current_weapon.hide()
		current_weapon = smg
		smg.show()
	if (Input.is_action_just_pressed("num2")):
		current_weapon.hide()
		current_weapon = revolver
		revolver.show()

	var weapon_animation = current_weapon.get_child(2)
	if Input.is_action_just_pressed("reload"):
		weapon_animation.play("reload")
		current_weapon._reload()

	var weapon_name = current_weapon.name
	var hit_point = aim_ray.get_collision_point()
	if Input.is_action_pressed("fire"):
		var target
		if aim_ray.is_colliding():
			target = aim_ray.get_collider()
		_shoot_gun(weapon_name, target, hit_point)
	
	move_and_slide()

func _process(_delta):
	if get_tree().paused:
		return  # Prevent player input while paused
	if health <= 0:
		die()
	pass

func _shoot_gun(gun, target, hit_point):
	match gun:
		"smg":
			smg._shoot(target, hit_point)
		"revolver":
			pass

func jump():
	velocity.y = jump_velocity

func _on_deathbox_body_entered(_body: Node3D) -> void:
	die()
	pass # Replace with function body.

func die():
	var spawn_location = Vector3(0,-1,7)
	player.global_position = spawn_location
	pass
