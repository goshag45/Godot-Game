extends Node3D

@onready var weapon = $".."
@onready var animation = $"../animation"
@onready var audio_component = $"../audio_component"
@onready var muzzle_flash = $"../muzzle_flash"

var magazine = 0
var magazine_capacity = 0
var damage = 0
var shoot_sound

var blood_splatter = preload("res://scenes/weapons/blood_splatter.tscn")
var bullet_decal = preload("res://scenes/weapons/bullet_decal.tscn")
var bullet_tracer = preload("res://scenes/weapons/bullet_tracer.tscn")
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

func shoot(target, hit_point):
	if !animation.is_playing():
		magazine -= 1
		animation.play(shoot_sound)
		audio_component._play_audio_sfx(shoot_sound, weapon.shoot_volume)
		process_embelishments(target, damage, hit_point)

func process_embelishments(target, damage, hit_point):
	#spawn_bullet_tracer(hit_point)
	if target != null && target.is_in_group("enemy"):
		target.health -= damage
		emit_blood_splatter(hit_point, target)
	elif target != null:
		draw_bullet_decals(hit_point)

func shoot_with_spread():
	var origin = global_position
	if !animation.is_playing():
		magazine -= 1
		animation.play(shoot_sound)
		audio_component._play_audio_sfx(shoot_sound, weapon.shoot_volume)
		
		var half = (weapon.pellet_grid_size - 1) / 2.0
		for i in range(weapon.pellet_count):
			var row = i / weapon.pellet_grid_size
			var col = i % weapon.pellet_grid_size

			var offset_x = (col - half) * weapon.pellet_spacing
			var offset_y = (row - half) * weapon.pellet_spacing

			var spread_dir = (-global_transform.basis.z.normalized() + global_transform.basis.x * offset_x + global_transform.basis.y * offset_y).normalized()
			var ray_length = 100.0
			var to = origin + spread_dir * ray_length

			# Cast a ray for each pellet
			var space_state = get_world_3d().direct_space_state
			var result = space_state.intersect_ray(
				PhysicsRayQueryParameters3D.create(origin, to)
			)

			DebugDraw3D.draw_line(origin, to, Color.RED)

			if result:
				var target = result.collider
				var hit_point = result.position
				process_embelishments(target, damage, hit_point)
				spawn_bullet_tracer(hit_point)

func reload():
	# you can spam the reload audio for now - not major issue
	audio_component._play_audio_sfx("reload", 3)
	animation.play("reload")
	magazine = magazine_capacity

func emit_blood_splatter(hit_pos : Vector3, target):
	var blood_splatter_instance = blood_splatter.instantiate()
	blood_splatter_instance.material_override.albedo_color = target.blood_color
	get_tree().current_scene.add_child(blood_splatter_instance)
	blood_splatter_instance.global_position = hit_pos
	blood_splatter_instance.look_at(aim_ray.global_position)
	blood_splatter_instance.emitting = true

func draw_bullet_decals(hit_pos : Vector3):
	var bullet_decal_instance = bullet_decal.instantiate()
	get_tree().current_scene.add_child(bullet_decal_instance)
	bullet_decal_instance.global_position = hit_pos
	bullet_decal_instance.look_at(aim_ray.get_collision_point() + aim_ray.get_collision_normal(), Vector3.UP)

func spawn_bullet_tracer(target_pos : Vector3):
	var tracer_instance = bullet_tracer.instantiate()
	get_tree().current_scene.add_child(tracer_instance)
	tracer_instance.target_pos = target_pos
	tracer_instance.global_position = muzzle_flash.global_position
	tracer_instance.look_at(target_pos)
