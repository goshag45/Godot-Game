extends Node3D

@export var INTENSITY : float = 15.0
@onready var position_node = $position

func _ready() -> void:
	for pieces:RigidBody3D in position_node.get_children():
		pieces.apply_impulse( pieces.get_child(0).position * INTENSITY, self.global_position )
		
	await get_tree().create_timer(3).timeout
	queue_free()
