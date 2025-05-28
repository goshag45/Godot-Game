extends Node3D

@onready var weapon = $".."
@onready var animation = $"../animation"
@onready var audio_component = $"../audio_component"
@onready var spawn_marker = $"../spawn_marker"

var magazine = 0
var magazine_capacity = 0
var damage = 0
var shoot_sound
var is_reloading = false

var blood_splatter = preload("res://scenes/weapons/blood_splatter.tscn")
var aim_ray: Node
var player

func _ready() -> void:
	aim_ray = get_tree().get_nodes_in_group("aim_ray")[0]
	player = get_tree().get_nodes_in_group("player")[0]
	magazine = weapon.magazine_capacity
	magazine_capacity = weapon.magazine_capacity
	damage = weapon.damage
	shoot_sound = weapon.shoot_sound

func _process(_delta: float) -> void:
	if magazine <= 0 and !animation.is_playing():
		reload()

func shoot():
	if !animation.is_playing():
		magazine -= 1
		animation.play(shoot_sound)
		audio_component._play_audio_sfx(shoot_sound, weapon.shoot_volume, false)

		var projectile_instance = weapon.projectile.instantiate()
		get_tree().current_scene.add_child(projectile_instance)
		projectile_instance.visible = false
		
		# this is getting the first person camera
		var fps_cam = player.get_child(0).get_child(0)
		projectile_instance.global_transform = fps_cam.global_transform
		projectile_instance.velocity = -fps_cam.global_transform.basis.z * projectile_instance.speed
		await get_tree().create_timer(0.1).timeout
		if projectile_instance:
			projectile_instance.visible = true

func reload():
	# you can spam the reload audio for now - not major issue
	audio_component._play_audio_sfx("reload", 3, false)
	animation.play("reload")
	magazine = magazine_capacity
