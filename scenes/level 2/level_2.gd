extends Node3D

@onready var player_spawn_location_1 = $terrain/spawn_location_1
@onready var spawn_button = $terrain/spawn_balls_button
@onready var enemy_manager = $enemy_manager

var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	spawn_button.press.connect(spawn_balls)
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
	player_instance.get_node("player_spawn_component").spawn_at(player_spawn_location_1)

func spawn_balls():
	#doesnt turn off, fine for now
	enemy_manager.spawn_flag = true
