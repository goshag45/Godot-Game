extends Node3D

@onready var spawn_button = $spawn_balls_button
@onready var spawn_region = $spawn_area/spawn_collision_area
var spawn_region_center = spawn_region.position

var deathbox = get_tree().get_first_node_in_group("deathbox")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	preload("res://scenes/gore_ball.tscn")
	spawn_button.press.connect(spawn_gore_ball)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_gore_ball():
	pass
