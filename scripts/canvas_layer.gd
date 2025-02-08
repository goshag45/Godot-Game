extends CanvasLayer

@onready var player_weapon = $"../Head/firstperson_camera/SubViewportContainer/SubViewport/ViewModelCamera/FPSRig/smg"
@onready var ammo_counter = $in_game_gui/Label
@onready var fps_counter = $in_game_gui/FPS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	ammo_counter.text = str(player_weapon.magazine)
	fps_counter.text = str("FPS %d" % Engine.get_frames_per_second())
