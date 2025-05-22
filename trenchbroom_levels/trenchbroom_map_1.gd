extends Node3D

var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
