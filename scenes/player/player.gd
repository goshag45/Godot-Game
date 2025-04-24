extends CharacterBody3D

# VARIABLES
@export_category("Player Stats")
@export var sensitivity_input = 0.8
#weird calc - stupid
var SENSITIVITY = sensitivity_input/1000
@export var jump_velocity = 4.5
@export var base_fov = 85
@export var fov_scale = 1.5
@export var gravity = 9.8
@export var speed = 8.0
@export var health = 10.0
@export var dash_velocity = 20

var kill_count = 0

# References
@onready var camera = $head/firstperson_camera
@onready var view_model_camera = $head/firstperson_camera/view_model/view_model_camera
@onready var player = $"."
@onready var audio_component = $audio_component
@onready var blood_orb = $head/firstperson_camera/view_model/view_model_camera/blood_orb_v2

var direction = Vector3()
var jump_sounds = ["jump1", "jump2", "jump3"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	global_signals.gore_ball_died.connect(_on_enemy_killed)
	global_signals.guck_cube_died.connect(_on_enemy_killed)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact2"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(_delta):
	if get_tree().paused:
		return  # Prevent player input while paused
	if health <= 0:
		die()
	
	var mat = blood_orb.find_child("blood").get_active_material(0)
	mat.set_shader_parameter('fill_amount', health/100.0 * 0.5 + 0.26)

func die():
	var spawn_location = Vector3(0,-1,7)
	player.global_position = spawn_location

func _on_enemy_killed():
	kill_count += 1
