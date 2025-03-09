extends Node3D

func spawn_at(location: Node3D):
	get_parent().global_position = location.global_position
