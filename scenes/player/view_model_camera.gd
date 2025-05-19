extends Camera3D

@export var margin_percent_x : float = 15.0
@export var margin_percent_y : float = 15.0 
@export var distance : float = 2.0 
@export var orb_scale : float = 0.5

@onready var orb = $blood_orb_v2
@onready var fps_rig = $fps_rig
@onready var gun_sway_hand = $gun_sway_hand
@onready var view_model = $".."
@onready var view_model_camera = $"."
@onready var player = get_tree().get_first_node_in_group("player")

# more sway = less sway
var SWAY : float = 150.0

# bob
@export var bob_speed = 100.0
@export var bob_amount = 150.0

func _ready():
	fps_rig.set_as_top_level(true)
	get_tree().get_root().size_changed.connect(update_orb) 
	call_deferred("update_orb")

func _physics_process(_delta: float) -> void:
	pass

func _process(delta: float) -> void:
	fps_rig.global_transform.origin = gun_sway_hand.global_transform.origin
	fps_rig.rotation.y = lerp_angle(fps_rig.rotation.y, view_model.global_rotation.y, SWAY * delta)
	fps_rig.rotation.x = lerp_angle(fps_rig.rotation.x, view_model.global_rotation.x, SWAY * delta)
	
	if player.is_on_floor():
		var time = float(Time.get_ticks_msec())
		fps_rig.position.y = fps_rig.position.y + sin(time / bob_speed) / bob_amount * player.velocity.length()

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
