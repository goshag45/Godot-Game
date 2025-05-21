extends Camera3D

@onready var player = $"../.."

var yaw: float = 0.0
var pitch: float = 0.0
@export var pitch_limit: float = 90.0 

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
	
	pitch = clamp(pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))
	
	_update_rotation()

func _update_rotation() -> void:
	var yaw_basis = Basis(Vector3.UP, yaw)
	var pitch_basis = Basis(Vector3.RIGHT, pitch)
	global_transform.basis = yaw_basis * pitch_basis
#
##INTERPOLATING
#extends Camera3D
#
#@export var follow_target: NodePath 
#@export var player: Node
#
#@onready var target: Node3D = null  # Reference to the follow target
#var prev_transform: Transform3D
#var current_transform: Transform3D
#
#var yaw: float = 0.0  # Horizontal rotation
#var pitch: float = 0.0  # Vertical rotation
#@export var pitch_limit: float = 80.0  # Maximum vertical rotation (in degrees)
#
#func _ready() -> void:
	## Ensure the follow_target is set up properly
	#target = get_node_or_null(follow_target)
#
	#prev_transform = target.global_transform
	#current_transform = prev_transform
#
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#_handle_mouse_input(event)
#
#func _handle_mouse_input(event: InputEventMouseMotion) -> void:
	## Rotate the camera based on mouse movement
	#yaw -= event.relative.x * player.SENSITIVITY
	#player.rotate_y(-event.relative.x * player.SENSITIVITY)
#
	#pitch -= event.relative.y * player.SENSITIVITY
	#pitch = clamp(pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))
#
#func _physics_process(_delta: float) -> void:
	#if target:
		## Update the previous transform for interpolation
		#prev_transform = current_transform
		#current_transform = target.global_transform
#
#func _process(_delta: float) -> void:
	#if target:
		## Interpolate position between physics frames
		#var interp_fraction = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
		#var interpolated_transform = prev_transform.interpolate_with(current_transform, interp_fraction)
#
		#global_transform.origin = interpolated_transform.origin
		#_update_rotation()
#
#func _update_rotation() -> void:
	#var yaw_basis = Basis(Vector3.UP, yaw)
	#var pitch_basis = Basis(Vector3.RIGHT, pitch)
	#global_transform.basis = yaw_basis * pitch_basis
