extends Node3D

@onready var player = $".."
@onready var dash_cooldown = $dash_cooldown

@export var camera : Camera3D
@export var view_model_camera = Camera3D
@export var audio_component = Node3D

var direction = Vector3()
var jump_sounds = ["jump1", "jump2", "jump3"]

var jump_velocity : float
var base_fov : int
var fov_scale : float
var gravity : float
var speed : float
var health : int
var dash_velocity : float

func _ready() -> void:
	jump_velocity = player.jump_velocity
	base_fov = player.base_fov
	fov_scale = player.fov_scale
	gravity = player.gravity
	speed = player.speed
	health = player.health
	dash_velocity = player.dash_velocity

func _physics_process(delta: float) -> void:
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
			player.velocity.x = direction.x * speed
			player.velocity.z = direction.z * speed
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
#	make dash in direction of player camera
	player.velocity.y += dash_velocity
	player.velocity.x * 2.0
	dash_cooldown.start(1.0)
