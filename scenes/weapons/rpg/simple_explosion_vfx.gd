extends Node3D

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()
