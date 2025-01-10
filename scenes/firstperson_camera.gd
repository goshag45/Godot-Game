extends Camera3D

@export var follow_target: NodePath  # The target to follow (e.g., the player)

@onready var player = $"../.."
@onready var target: Node3D = null  # Reference to the follow target
var prev_transform: Transform3D
var current_transform: Transform3D

var yaw: float = 0.0  # Horizontal rotation
var pitch: float = 0.0  # Vertical rotation
@export var pitch_limit: float = 90.0  # Maximum vertical rotation (in degrees)

func _ready() -> void:
	# Ensure the follow_target is set up properly
	target = get_node_or_null(follow_target)
	if target == null:
		push_error("Follow target is not assigned or invalid!")
		return
	
	# Initialize previous and current transforms
	prev_transform = target.global_transform
	current_transform = prev_transform
	
	# Lock the mouse for first-person control
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse_input(event)

func _handle_mouse_input(event: InputEventMouseMotion) -> void:
	# Rotate the camera based on mouse movement
	player.rotate_y(-event.relative.x * player.SENSITIVITY)
	yaw -= event.relative.x * player.SENSITIVITY
	pitch -= event.relative.y * player.SENSITIVITY
	
	# Clamp pitch to avoid flipping
	pitch = clamp(pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))

func _physics_process(_delta: float) -> void:
	if target:
		# Update the previous transform for interpolation
		prev_transform = current_transform
		current_transform = target.global_transform

func _process(_delta: float) -> void:
	if target:
		# Interpolate position between physics frames
		var interp_fraction = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
		var interpolated_transform = prev_transform.interpolate_with(current_transform, interp_fraction)
		
		# Update position
		global_transform.origin = interpolated_transform.origin
		
		# Apply rotations
		_update_rotation()

func _update_rotation() -> void:
	# Create a basis for yaw (horizontal rotation around global Y-axis)
	var yaw_basis = Basis(Vector3.UP, yaw)
	
	# Create a basis for pitch (vertical rotation around the camera's local X-axis)
	var pitch_basis = Basis(Vector3.RIGHT, pitch)
	
	# Combine yaw and pitch rotations
	global_transform.basis = yaw_basis * pitch_basis
