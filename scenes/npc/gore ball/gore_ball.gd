extends RigidBody3D

@export var health = 100
@export var blood_color : Color = Color.RED
@export var pieces : PackedScene

@export var acceleration_force: float = 30.0  # Force applied for acceleration
@export var max_horizontal_speed: float = 10.0  # Maximum speed on the XZ plane
#@export var max_vertical_speed: float = 20.0  # Maximum speed on the Y axis

@onready var nav_agent = $nav_agent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component
# default mass is 0.2 

@export var max_death_sounds : int =  5
var death_sounds : int =  0

func _ready():
	linear_damp = 0.1
	angular_damp = 0.05
	mass = 1.0
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")
	nav_agent.target_position = player.global_position
	nav_agent.path_desired_distance = 0.8

func setup():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if Engine.get_physics_frames() % 4 != self.get_instance_id() % 4:
		return  # Skip update 3/4 frames
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

		## Enforce vertical speed limit (Y axis)
		#if abs(linear_velocity.y) > max_vertical_speed:
			#linear_velocity.y = sign(linear_velocity.y) * max_vertical_speed


func _process(_delta):
	if health <= 0:
		die()

func die():
	global_signals._gore_ball_died.emit()
	audio_component._play_audio_sfx("blood_squelch", 3, true)
	explode()
	call_deferred("queue_free")

func explode():
	var pieces_instance = pieces.instantiate()
	get_tree().current_scene.add_child(pieces_instance)
	pieces_instance.call_deferred("set_global_position", global_position)
