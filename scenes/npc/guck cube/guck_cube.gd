extends RigidBody3D

@export var health = 300
@export var blood_color : Color = Color.GREEN

enum State { IDLE, TOPPLING }
var state: State = State.IDLE
var topple_timer := 0.0
@export var topple_delay := 0.3  # seconds to wait before next topple
@export var min_angular_velocity := 0.05  # cube is considered "landed" 
@export var torque_strength: float = 20.0

@onready var nav_agent = $nav_agent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component
@onready var hitbox = $hitbox

func _ready():
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")

func setup():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")
	if not player:
		return

	if nav_agent and player:
		nav_agent.target_position = player.global_transform.origin
		var next_position: Vector3 = nav_agent.get_next_path_position()

	match state:
		State.IDLE:
			if angular_velocity.length() < min_angular_velocity:
				topple_timer -= delta
				if topple_timer <= 0:
					start_topple()

		State.TOPPLING:
			if angular_velocity.length() < min_angular_velocity:
				# Landed
				state = State.IDLE
				topple_timer = topple_delay

func start_topple():
	var next_position = nav_agent.get_next_path_position()
	print(next_position)
	var direction = (next_position - global_transform.origin)
	print(global_transform.origin)
	direction.y = 0
	direction = direction.normalized()

	var torque_axis = Vector3.UP.cross(direction).normalized()
	apply_torque_impulse(torque_axis * torque_strength)
	state = State.TOPPLING
	# DEBUG DRAW
	DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + direction * 2.0, Color.GREEN, 10.0)
	#print(direction)
	DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + torque_axis * 2.0, Color.BLUE, 10.0)
	#print(torque_axis)

func _process(_delta):
	if health <= 0:
		die()

func die():
	global_signals.guck_cube_died.emit()
	audio_component._play_audio_sfx("fart", 3)
	queue_free()
