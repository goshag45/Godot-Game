extends RigidBody3D

@export var health = 100
@export var player_path  : NodePath #NEED TO REFERENCE PLAYER SOMEHOW

@export var acceleration_force: float = 2.0  # Force applied for acceleration
@export var max_speed: float = 3.0  # Maximum speed of the ball
@export var turn_speed: float = 5.0  # How quickly the ball can adjust its direction

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component

func _ready():
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")
	nav_agent.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if nav_agent and player:
		# Update the target position for pathfinding
		nav_agent.target_position = player.global_transform.origin
		# Get the next navigation point
		var next_position: Vector3 = nav_agent.get_next_path_position()
		# Calculate the direction toward the next navigation point
		var direction: Vector3 = (next_position - global_transform.origin)
		direction.y = 0  # Keep movement on the horizontal plane
		direction = direction.normalized()
		# Apply a force to move the ball in the desired direction
		var current_velocity: Vector3 = linear_velocity
		var desired_velocity: Vector3 = direction * max_speed
		linear_velocity = current_velocity.lerp(desired_velocity, turn_speed * delta)
		# Enforce max speed
		if linear_velocity.length() > max_speed:
			linear_velocity = linear_velocity.normalized() * max_speed
		# Apply central force for acceleration
		var force: Vector3 = direction * acceleration_force
		apply_central_force(force)
		## Keep grounded
		#linear_velocity.y = 0

func _process(_delta):
	if health <= 0:
		die()

func setup():
	await get_tree().physics_frame
	set_physics_process(true)

func die():
	# cant make the audio work kill me
	#audio_component._play_audio_sfx("blood_squelch")
	queue_free()
