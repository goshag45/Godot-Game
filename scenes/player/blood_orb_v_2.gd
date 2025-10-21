extends Node3D

@onready var liquid = $blood

func _process(delta):
	liquid.rotation = Vector3.ZERO
