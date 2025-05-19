extends RigidBody3D

@export var health = 300
@export var blood_color : Color = Color.GREEN
@export var pieces : PackedScene 

enum State { IDLE, TOPPLING }
var state: State = State.IDLE
var topple_timer := 0.0
@export var topple_delay := 0.3  # seconds to wait before next topple
@export var min_angular_velocity := 0.05  # cube is considered "landed" 
@export var torque_strength: float

@onready var nav_agent = $nav_agent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component
@onready var hitbox = $hitbox

var next_position: Vector3
var direction: Vector3
var torque_axis: Vector3

var augh_sounds = ["augh1", "augh2", "augh3"]

func _ready():
	mass = 5.0
	nav_agent.path_desired_distance = 2.0
	angular_damp = 1.0
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")

func setup():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	torque_strength = randf_range(120.0, 140.0)
	if not player:
		player = get_tree().get_first_node_in_group("player")
	nav_agent.target_position = player.global_transform.origin
	if nav_agent.is_navigation_finished():
		return

	next_position = nav_agent.get_next_path_position()
	direction = next_position - global_transform.origin
	direction.y = 0
	direction = direction.normalized()

	torque_axis = Vector3.UP.cross(direction).normalized()

	match state:
		State.IDLE:
			if angular_velocity.length() < min_angular_velocity:
				topple_timer -= delta
				if topple_timer <= 0:
					start_topple()

		State.TOPPLING:
			if angular_velocity.length() < min_angular_velocity:
				state = State.IDLE
				topple_timer = topple_delay

func start_topple():
	#audio_component._play_random_sfx(augh_sounds, 6)
	apply_torque_impulse(torque_axis * torque_strength)
	state = State.TOPPLING

func _process(_delta):
	if health <= 0:
		die()

func die():
	global_signals._guck_cube_died.emit()
	audio_component._play_audio_sfx("fart", 3)
	explode()
	call_deferred("queue_free")

func explode():
	var pieces_instance = pieces.instantiate()
	get_tree().current_scene.add_child(pieces_instance)
	pieces_instance.call_deferred("set_global_position", global_position)
