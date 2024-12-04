extends CanvasLayer

@onready var player_weapon = $"../Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera/FPSRig/Revolver"
@onready var ammo_counter = $Control/Label
@onready var fps_counter = $Control/FPS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ammo_counter.text = str(player_weapon.mag_size)
	fps_counter.text = str("FPS %d" % Engine.get_frames_per_second())
