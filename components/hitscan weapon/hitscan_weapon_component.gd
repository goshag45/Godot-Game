extends Node3D

@onready var weapon = $".."
@onready var animation = $"../animation"
@onready var audio_component = $"../audio_component"

var magazine = 0
var magazine_capacity = 0
var damage = 0
var shoot_sound
var is_reloading = false

var blood_splatter = preload("res://scenes/weapons/blood_splatter.tscn")
var bullet_decal = preload("res://scenes/weapons/bullet_decal.tscn")
var aim_ray: Node

func _ready() -> void:
	aim_ray = get_tree().get_nodes_in_group("aim_ray")[0]
	magazine = weapon.magazine_capacity
	magazine_capacity = weapon.magazine_capacity
	damage = weapon.damage
	shoot_sound = weapon.shoot_sound

func _process(_delta: float) -> void:
	if magazine <= 0 and !animation.is_playing():
		_reload()

func _shoot(target, hit_point):
	if !animation.is_playing():
		magazine -= 1
		animation.play(shoot_sound)
		audio_component._play_audio_sfx(shoot_sound, weapon.shoot_volume)
		if target != null && target.is_in_group("enemy"):
			target.health -= damage
			_emit_blood_splatter(hit_point, target)
		elif target != null:
			_draw_bullet_decals(hit_point)

func _reload():
	# you can spam the reload audio for now - not major issue
	audio_component._play_audio_sfx("reload", 3)
	animation.play("reload")
	magazine = magazine_capacity

func _emit_blood_splatter(hit_pos, target):
	var blood_splatter_instance = blood_splatter.instantiate()
	blood_splatter_instance.material_override.albedo_color = target.blood_color
	# Add to world
	var world_node = get_tree().current_scene
	world_node.add_child(blood_splatter_instance)
	# Correct positioning
	blood_splatter_instance.global_position = hit_pos
	# Set blood splatter's rotation to face opposite the bullet's direction
	blood_splatter_instance.look_at(aim_ray.global_position)
	# Enable emission
	blood_splatter_instance.emitting = true

func _draw_bullet_decals(hit_pos):
	var bullet_decal_instance = bullet_decal.instantiate()
	var world_node = get_tree().current_scene
	world_node.add_child(bullet_decal_instance)
	bullet_decal_instance.global_position = hit_pos
	bullet_decal_instance.look_at(aim_ray.get_collision_point() + aim_ray.get_collision_normal(), Vector3.UP)
