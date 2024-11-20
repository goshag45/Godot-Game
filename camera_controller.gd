extends Node3D

var player
@export var sensitivity := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player.global_position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var temp_rotation = rotation.x - event.relative.y / 1000 * sensitivity
		rotation.y -= event.relative.x / 1000 * sensitivity
		temp_rotation = clamp(temp_rotation, -1, 0.35)
		rotation.x = temp_rotation
