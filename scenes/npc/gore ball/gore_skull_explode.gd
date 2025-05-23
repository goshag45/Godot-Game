extends Node3D

@export var INTENSITY : float
@onready var position_node = $position

func _ready() -> void:
	for pieces:RigidBody3D in position_node.get_children():
		INTENSITY = randf_range(10.0, 20.0)
		pieces.apply_impulse( pieces.get_child(0).position * INTENSITY, self.global_position )
		
	await get_tree().create_timer(3).timeout
	queue_free()
