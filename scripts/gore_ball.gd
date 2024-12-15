extends CharacterBody3D

@export var health = 200
@export var player_path  : NodePath #NEED TO REFERENCE PLAYER SOMEHOW
@export var speed = 4.0

@onready var nav_agent = $NavigationAgent3D

var player = null

func _ready():
	player = get_node(player_path)

func _physics_process(delta: float) -> void:
	pass

func _process(delta):
	if health <= 0:
		queue_free()
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_position.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	move_and_slide()
