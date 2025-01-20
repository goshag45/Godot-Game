extends Node3D

var deathbox = get_tree().get_first_node_in_group("deathbox")

func _ready() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	pass

func _process(delta: float) -> void:
	pass

func spawn_gore_ball():
	pass

func _on_deathbox_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
