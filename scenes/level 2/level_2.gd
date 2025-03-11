extends Node3D

@onready var spawn_location_1 = $terrain/spawn_location_1

var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
	player_instance.get_node("player_spawn_component").spawn_at(spawn_location_1)
