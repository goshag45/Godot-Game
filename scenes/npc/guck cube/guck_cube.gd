extends RigidBody3D

@export var health = 300

@export var acceleration_force: float = 5.0

@onready var nav_agent = $nav_agent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_component = $audio_component
