extends CharacterBody3D

# VARIABLES
@export var SENSITIVITY = 0.0013
var speed
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var jump_velocity = 4.5
@export var base_fov = 90
@export var fov_scale = 1.5
@export var gravity = 9.8
@export var ammo_revolver = 6

#head bob stuff
const BOB_FREQ = 2.0
const BOB_AMP = 0.04
var t_bob = 0.0

# References
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var player = $"."

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print("rotating")
		player.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(90))


func _physics_process(delta: float) -> void:
	# FINISH KILLBOX CODE HERE
	var deathbox = get_tree().get_first_node_in_group("deathbox")

	if Input.is_action_just_pressed("fire"):
		print("shooted")

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
	var direction = -(player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()

func _headbob(time):
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = sin(time * BOB_FREQ / 2) * BOB_AMP
	return pos
