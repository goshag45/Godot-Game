extends Node3D

@onready var spawn_button = $spawn_balls_button
@onready var spawn_location = $spawn_area/spawn_collision_area

#var deathbox = get_tree().get_first_node_in_group("deathbox")
var gore_ball = preload("res://scenes/npc/gore_ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_button.press.connect(spawn_gore_ball)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_gore_ball():
	var spawn_region_center = spawn_location.global_position
	var gore_ball_instance = gore_ball.instantiate()
	add_child(gore_ball_instance)
	gore_ball_instance.global_position = spawn_region_center
	print("spawned goreball at ", spawn_region_center)
