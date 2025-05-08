extends Node3D

@export var player : CharacterBody3D
@onready var dash_cooldown = $dash_cooldown
@export var camera : Camera3D
@export var view_model_camera : Camera3D
@export var audio_component : Node3D
@export var dash_area_collision: Area3D
@export var effect : ColorRect

var direction = Vector3()
var jump_sounds = ["jump1", "jump2", "jump3"]

var jump_velocity : float
var gravity : float
var speed : float
var health : int
var dash_velocity : int

var default_fov : float
var player_velocity_length : float
var target_velocity_fov : float

func _ready() -> void:
	default_fov = player.default_fov
	jump_velocity = player.jump_velocity
	gravity = player.gravity
	speed = player.speed
	health = player.health
	dash_velocity = player.dash_velocity

func _physics_process(delta: float) -> void:
	player_velocity_length = player.velocity.length()
	if player_velocity_length > 0:
		var velocity_factor = clamp(player_velocity_length / 7.6, 1.0, 1.4)
		target_velocity_fov = clamp(default_fov * velocity_factor, 70.0, 100.0)
		camera.fov = lerp(camera.fov, target_velocity_fov, 0.1)
		print(target_velocity_fov)
	
	apply_aberration()
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		jump()

	if Input.is_action_just_pressed("sprint") and dash_cooldown.time_left == 0:
		dash()

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if player.is_on_floor():
		if direction:
			player.velocity.x = lerp(player.velocity.x, direction.x * speed, delta * 10.0)
			player.velocity.z = lerp(player.velocity.z, direction.z * speed, delta * 10.0)
			#player.velocity.x = direction.x * speed
			#player.velocity.z = direction.z * speed
		else:
			player.velocity.x = 0.0
			player.velocity.z = 0.0
	else:
		player.velocity.x = lerp(player.velocity.x, direction.x * speed, delta * 4.0)
		player.velocity.z = lerp(player.velocity.z, direction.z * speed, delta * 4.0)

	player.move_and_slide()

func jump():
	player.velocity.y = jump_velocity
	audio_component._play_random_sfx(jump_sounds, 6)

func dash():
	apply_dash_impulse()
	var dash_direction = -camera.global_basis.z
	var velocity = dash_velocity * dash_direction
#	make dash in direction of player camera
	player.velocity += velocity
	dash_cooldown.start(1.0)

func apply_dash_impulse():
	var bodies = dash_area_collision.get_overlapping_bodies()  # assuming you're using an Area3D
	for body in bodies:
		if body is RigidBody3D:
			var dir = (body.global_transform.origin - global_transform.origin).normalized()
			body.apply_impulse(dir * 10.0)

func apply_aberration():
	var initial_strength = effect.material.get_shader_parameter("initial_strength")
	var final_strength = initial_strength * player.velocity.length() / 10
	effect.material.set_shader_parameter("final_strength", final_strength)
