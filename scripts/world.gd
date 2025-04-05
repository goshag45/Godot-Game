extends Node3D

func _ready() -> void:
	get_window().size = Vector2i(1280, 960)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact2"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
