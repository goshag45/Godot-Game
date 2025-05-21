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

func _ready() -> void:
	aim_ray = get_tree().get_nodes_in_group("aim_ray")[0]
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
		projectile_instance.global_transform = spawn_marker.global_transform
		projectile_instance.velocity = spawn_marker.global_transform.basis.z * projectile_instance.speed

func reload():
	# you can spam the reload audio for now - not major issue
	audio_component._play_audio_sfx("reload", 3, false)
	animation.play("reload")
	magazine = magazine_capacity
