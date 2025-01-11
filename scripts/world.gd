extends Node3D

@onready var spawn_button = $spawn_balls_button

var deathbox = get_tree().get_first_node_in_group("deathbox")

func _ready() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	preload("res://scenes/gore_ball.tscn")
	spawn_button.press.connect(spawn_gore_ball)
	pass

func _process(delta: float) -> void:
	pass

func spawn_gore_ball():
	pass
