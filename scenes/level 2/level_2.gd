extends Node3D

@onready var player_spawn_location_1 = $terrain/spawn_location_1
@onready var spawn_button = $terrain/spawn_balls_button
@onready var enemy_manager = $enemy_manager
@onready var da_aura = $"terrain/da aura"
@onready var audio_component = $audio_component

var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	da_aura.hide()
	spawn_button.press.connect(spawn_balls)
	#add_player()

func spawn_balls():
	#doesnt turn off, fine for now
	enemy_manager.spawn_flag = true

func _on_thedavy_da_aura() -> void:
	da_aura.show()

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
