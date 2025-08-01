extends Node3D

@onready var camera = $menu_camera

func _ready():
	get_tree().paused = false

func _process(delta: float) -> void:
	pass
	#print("Camera transform on main menu load: ", camera.global_transform)
