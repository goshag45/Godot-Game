extends RigidBody3D

@export var health = 100
@export var player_path  : NodePath #NEED TO REFERENCE PLAYER SOMEHOW
@export var speed = 3.0

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	# quick fix to pause physics for a frame to wait for navigation server to work
	set_physics_process(false)
	call_deferred("setup")

func _physics_process(_delta: float) -> void:
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	pass

func _process(_delta):
	if health <= 0:
		queue_free()

func setup():
	await get_tree().physics_frame
	set_physics_process(true)
