extends RigidBody3D

@export var health = 300
@export var blood_color : Color = Color.GREEN

@export var acceleration_force: float = 1.0
var topple_cooldown := 0.0
@export var topple_delay := 0.75  # seconds between topples
@export var angular_velocity_threshold := 0.1

@onready var nav_agent = $nav_agent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component

func _ready():
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")

func setup():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(_delta) -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		nav_agent.target_position = player.global_position

	# Get the next navigation point
	var next_position: Vector3 = nav_agent.get_next_path_position()
	# Calculate the direction toward the next navigation point
	var direction: Vector3 = (next_position - global_transform.origin)
	direction.y = 0  # Ignore vertical movement for navigation
	direction = direction.normalized()

	if direction.length() > 0.1:
		var up = Vector3.UP
		var torque_axis = up.cross(direction).normalized()
		var torque_strength = acceleration_force  # tweak as needed
		apply_torque_impulse(torque_axis * torque_strength)

func _process(_delta):
	if health <= 0:
		die()

func die():
	global_signals.guck_cube_died.emit()
	audio_component._play_audio_sfx("fart", 3)
	queue_free()
