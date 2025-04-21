extends Camera3D

@export var margin_percent_x : float = 15.0
@export var margin_percent_y : float = 15.0 
@export var distance : float = 2.0 
@export var orb_scale : float = 0.5
@onready var orb = $blood_orb_v2

func _ready():
	get_tree().get_root().size_changed.connect(update_orb) 
	call_deferred("update_orb")

func _physics_process(_delta: float) -> void:
	pass

func update_orb():
	var viewport := get_viewport()
	var screen_size = viewport.size

	var viewport_pos := Vector2(
		screen_size.x * (margin_percent_x / 100),
		screen_size.y * (margin_percent_y / 100)
	)
	
	# Position orb in 3D space
	orb.global_position = project_position(viewport_pos, distance)
	
	# Simple fixed scale (adjust multiplier as needed)
	orb.scale = Vector3.ONE * distance * orb_scale
