extends RigidBody3D

@export var health = 300

@export var acceleration_force: float = 5.0

@onready var nav_agent = $nav_agent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component

func _ready():
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")
	#nav_agent.target_position = player.global_position

func setup():
	await get_tree().physics_frame
	set_physics_process(true)
	
func _process(_delta):
	if health <= 0:
		die()

func die():
	global_signals.guck_cube_died.emit()
	audio_component._play_audio_sfx("blood_squelch", 3)
	queue_free()
