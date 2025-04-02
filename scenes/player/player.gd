extends CharacterBody3D

# VARIABLES
@export_category("Player Stats")
@export var sensitivity_input = 0.8 # CANT GO TO 2 OR HIGHER FOR SOME REASON????
#weird calc - stupid
var SENSITIVITY = sensitivity_input/1000
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var base_fov = 85
@export var fov_scale = 1.5
@export var gravity = 9.8
@export var ammo_revolver = 6
@export var speed = walk_speed
@export var health = 100

var kill_count = 0

# References
@onready var camera = $head/firstperson_camera
@onready var view_model_camera = $head/firstperson_camera/view_model/view_model_camera
@onready var player = $"."
@onready var audio_component = $audio_component

var direction = Vector3()
var jump_sounds = ["jump1", "jump2", "jump3"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	global_signals.gore_ball_died.connect(_on_enemy_killed)

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

	move_and_slide()

func _process(_delta):
	if get_tree().paused:
		return  # Prevent player input while paused
	if health <= 0:
		die()
	pass

func jump():
	velocity.y = jump_velocity

func _on_deathbox_body_entered(_body: Node3D) -> void:
	die()

func die():
	var spawn_location = Vector3(0,-1,7)
	player.global_position = spawn_location

func _on_enemy_killed():
	kill_count += 1
