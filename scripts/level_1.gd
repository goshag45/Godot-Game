extends Node3D

@onready var spawn_button = $world/spawn_balls_button
@onready var ball_spawn_location = $world/spawn_area/spawn_collision_area
@onready var spawn_location_1 = $world/spawn_location_1

#var deathbox = get_tree().get_first_node_in_group("deathbox")
var gore_ball = preload("res://scenes/npc/gore_ball.tscn")
var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	spawn_button.press.connect(spawn_gore_ball)
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
	player_instance.get_node("player_spawn_component").spawn_at(spawn_location_1)

func _process(_delta: float) -> void:
	pass

func spawn_gore_ball():
	var ball_spawn_region_center = ball_spawn_location.global_position
	var gore_ball_instance = gore_ball.instantiate()
	add_child(gore_ball_instance)
	gore_ball_instance.global_position = ball_spawn_region_center
