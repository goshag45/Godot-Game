extends Node3D

@export var player_spawn_location_1 : Node3D
var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	add_player()

func _on_deathbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
	if body.is_in_group("enemy"):
		body.die()

func add_player():
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
	player_instance.get_node("player_spawn_component").spawn_at(player_spawn_location_1)
	player_instance.audio_component._play_audio_sfx("vine_boom", 8.0, false)
