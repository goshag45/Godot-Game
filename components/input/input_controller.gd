extends Node

@onready var pause_menu = $"../pause_menu"

var is_paused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_pause_game()

func _pause_game():
	# press escape to show mouse
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = !is_paused
		is_paused = !is_paused
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu.show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			pause_menu.hide()
