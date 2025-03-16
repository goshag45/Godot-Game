extends Node3D

@export var gore_ball: PackedScene
@export var player: CharacterBody3D
@export var spawn_radius: float = 30.0
@export var initial_spawn_rate: float = 1.5 # seconds between spawns
@export var acceleration: float = 0.99 # Reduces spawn interval each cycle

var spawn_rate: float
var spawn_timer: float = 0.0
var spawn_flag = false

func _ready():
	spawn_rate = initial_spawn_rate
	await get_tree().process_frame # Ensure all nodes are added first
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Player not found!")

func _process(delta):
	spawn_timer -= delta
	if spawn_flag:
		if spawn_timer <= 0:
			spawn_enemy()
			spawn_timer = spawn_rate
			spawn_rate *= acceleration # Reduce time interval to speed up spawning

func spawn_enemy():
	if not player:
		player = get_tree().get_first_node_in_group("player") # Ensure player is still valid
		if not player:
			print("No player found, skipping spawn")
			return
	var spawn_position = get_random_spawn_position()
	var enemy = gore_ball.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_position # Moved this line outside the check


func get_random_spawn_position() -> Vector3:
	var angle = randf() * TAU
	var distance = randf_range(2.0, spawn_radius) # Avoids 0 distance
	var offset = Vector3(cos(angle), 0, sin(angle)) * distance
	
	var spawn_position = player.global_position + offset
	spawn_position.y += 2.0 # Ensure it's above the ground
	return spawn_position
