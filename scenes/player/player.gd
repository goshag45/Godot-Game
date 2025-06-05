extends CharacterBody3D

# VARIABLES
@export_category("Player Stats")
@export var sensitivity_input = 0.8
#weird calc - stupid
var SENSITIVITY = sensitivity_input/1000
@export var jump_velocity = 4.5
@export var gravity = 9.8
@export var speed = 8.0
@export var health = 100.0
@export var dash_velocity = 20
@export var default_fov = 70.0

var kill_count = 0

# References
@export var camera: Camera3D
@export var view_model_camera: Camera3D
@export var audio_component: Node3D
@export var blood_orb: Node3D

var direction = Vector3()
var jump_sounds = ["jump1", "jump2", "jump3"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	global_signals._gore_ball_died.connect(_on_enemy_killed)
	global_signals._guck_cube_died.connect(_on_enemy_killed)

func _physics_process(_delta: float) -> void:
	# fullscreen keybind for now
	if Input.is_action_just_pressed("interact2") and DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(_delta):
	if get_tree().paused:
		return  # Prevent player input while paused
	if health <= 0:
		die()
	
	var mat = blood_orb.find_child("blood").get_active_material(0)
	mat.set_shader_parameter('fill_amount', health/100.0 * 0.5 + 0.26)

func die():
	get_tree().reload_current_scene()

func _on_enemy_killed():
	kill_count += 1

func _apply_damage(damage : int):
	health -= damage
	audio_component._play_audio_sfx("player_take_damage", 2.0)
