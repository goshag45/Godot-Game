extends RigidBody3D

@export var health = 100
@export var player_path  : NodePath #NEED TO REFERENCE PLAYER SOMEHOW

@export var acceleration_force: float = 2.0  # Force applied for acceleration
@export var max_horizontal_speed: float = 10.0  # Maximum speed on the XZ plane
@export var max_vertical_speed: float = 20.0  # Maximum speed on the Y axis
@export var turn_speed: float = 5.0  # How quickly the ball can adjust its direction

@onready var nav_agent = $nav_agent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component

func _ready():
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")
	nav_agent.target_position = player.global_position

func _physics_process(_delta: float) -> void:
	if nav_agent and player:
		# Update the target position for pathfinding
		nav_agent.target_position = player.global_transform.origin

		# Get the next navigation point
		var next_position: Vector3 = nav_agent.get_next_path_position()

		# Calculate the direction toward the next navigation point
		var direction: Vector3 = (next_position - global_transform.origin)
		direction.y = 0  # Ignore vertical movement for navigation
		direction = direction.normalized()

		# Apply central force for acceleration
		var force: Vector3 = direction * acceleration_force
		apply_central_force(force)

		# Enforce horizontal speed limit (XZ plane)
		var horizontal_velocity: Vector3 = Vector3(linear_velocity.x, 0, linear_velocity.z)
		if horizontal_velocity.length() > max_horizontal_speed:
			horizontal_velocity = horizontal_velocity.normalized() * max_horizontal_speed
			linear_velocity.x = horizontal_velocity.x
			linear_velocity.z = horizontal_velocity.z

		# Enforce vertical speed limit (Y axis)
		if abs(linear_velocity.y) > max_vertical_speed:
			linear_velocity.y = sign(linear_velocity.y) * max_vertical_speed


func _process(_delta):
	if health <= 0:
		die()

func setup():
	await get_tree().physics_frame
	set_physics_process(true)

func die():
	# cant make the audio work kill me
	audio_component._play_audio_sfx("blood_squelch", 3)
	queue_free()
