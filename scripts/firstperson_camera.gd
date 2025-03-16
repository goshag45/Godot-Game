extends Camera3D

@onready var player = $"../.."

var yaw: float = 0.0  # Horizontal rotation
var pitch: float = 0.0  # Vertical rotation
@export var pitch_limit: float = 90.0  # Maximum vertical rotation (in degrees)

func _ready() -> void:
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
	
	_update_rotation()

func _update_rotation() -> void:
	# Create a basis for yaw (horizontal rotation around global Y-axis)
	var yaw_basis = Basis(Vector3.UP, yaw)
	
	# Create a basis for pitch (vertical rotation around the camera's local X-axis)
	var pitch_basis = Basis(Vector3.RIGHT, pitch)
	
	# Combine yaw and pitch rotations
	global_transform.basis = yaw_basis * pitch_basis
