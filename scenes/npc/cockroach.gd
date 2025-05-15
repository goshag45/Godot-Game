extends CharacterBody3D

@export var health = 100
@export var blood_color : Color = Color.FLORAL_WHITE
@export var speed : float = 8.0

@export var audio_component : Node3D
@export var hitbox : CollisionShape3D
@export var nav_agent : NavigationAgent3D
@export var animation : AnimationPlayer

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	nav_agent.path_desired_distance = 1.0

func _physics_process(_delta: float) -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")
	nav_agent.target_position = player.global_transform.origin

	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()

	velocity = direction * speed
	look_at(player.global_position)
	rotation.x = 0
	rotation.z = 0
	move_and_slide()

func _process(_delta):
	if health <= 0:
		die()

func die():
	global_signals.cockroach_died.emit()
	#make this a bug squash sound
	audio_component._play_audio_sfx("fart", 3)
	queue_free()

func animate():
	pass
