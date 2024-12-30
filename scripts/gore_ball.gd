extends CharacterBody3D

@export var health = 100
@export var player_path  : NodePath #NEED TO REFERENCE PLAYER SOMEHOW
@export var speed = 3.0

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	move_and_slide()
	pass

func _process(_delta):
	if health <= 0:
		queue_free()
