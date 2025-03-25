extends Camera3D

@export var pixel_margin_x : int = 100  # pixels from left
@export var pixel_margin_y : int = 100  # pixels from top
@export var distance : float = 2.0  # meters from camera
@onready var orb = $blood_orb_v2

func _process(_delta):
	var viewport := get_viewport()
	var screen_size = viewport.size
	
	# Convert to viewport coordinates (0-1)
	var viewport_pos := Vector2(
		pixel_margin_x / screen_size.x,
		pixel_margin_y / screen_size.y
	)
	
	# Position orb in 3D space
	orb.global_position = project_position(viewport_pos, distance)
	
	# Simple fixed scale (adjust multiplier as needed)
	orb.scale = Vector3.ONE * distance * 0.2
