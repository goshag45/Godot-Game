extends Node3D

@onready var weapon = $".."
@onready var animation = $"../animation"
@onready var audio_component = $"../audio_component"
@onready var muzzle_flash = $"../muzzle_flash"
var bullet_casing_spawn_node

var magazine = 0
var magazine_capacity = 0
var damage = 0
var shoot_sound

var blood_splatter = preload("res://scenes/weapons/blood_splatter.tscn")
var bullet_decal = preload("res://scenes/weapons/bullet_decal.tscn")
var bullet_tracer = preload("res://scenes/weapons/bullet_tracer.tscn")
var bullet_casing_9mm = preload("res://scenes/weapons/bullet_casing.tscn")
@export var aim_ray: RayCast3D
@export var player : CharacterBody3D

func _ready() -> void:
	if get_node_or_null("../bullet_casing_spawn_node"):
		bullet_casing_spawn_node = $"../bullet_casing_spawn_node"
	aim_ray = get_tree().get_nodes_in_group("aim_ray")[0]
	magazine = weapon.magazine_capacity
	magazine_capacity = weapon.magazine_capacity
	damage = weapon.damage
	shoot_sound = weapon.shoot_sound

func _process(_delta: float) -> void:
	#_draw_debug_axes(weapon)
	if magazine <= 0 and !animation.is_playing():
		reload()

func shoot(target, hit_point):
	if !animation.is_playing():
		magazine -= 1
		animation.play(shoot_sound)
		audio_component._play_audio_sfx(shoot_sound, weapon.shoot_volume, false)
		spawn_bullet_tracer(hit_point)
		process_embelishments(target, hit_point)
		if weapon.name == "smg":
			spawn_bullet_casing()

func shoot_with_spread():
	var origin = global_position
	if !animation.is_playing():
		magazine -= 1
		animation.play(shoot_sound)
		audio_component._play_audio_sfx(shoot_sound, weapon.shoot_volume, false)
		if !player.is_on_floor():
			physics_impulse()

		for i in range(weapon.pellet_count):
			var direction = -global_transform.basis.z.normalized() # forward
			var spread_angle = deg_to_rad(weapon.spread_angle_degrees) # e.g. 5–10 degrees
			var spread_dir = direction + (
				global_transform.basis.x * randf_range(-1.0, 1.0) +
				global_transform.basis.y * randf_range(-1.0, 1.0)
			) * tan(spread_angle)

			spread_dir = spread_dir.normalized()
			var ray_length = 100.0
			var destination = origin + spread_dir * ray_length

			var space_state = get_world_3d().direct_space_state
			var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(origin, destination))
			spawn_bullet_tracer(result.position if result else destination)
			if result:
				process_embelishments(result.collider, result.position)

func physics_impulse():
	var force: float = 10.0
	var direction = -global_transform.basis.z.normalized()
	var impulse = -direction * force
	player.velocity += impulse

func reload():
	# you can spam the reload audio for now - not major issue
	audio_component._play_audio_sfx("reload", 3, false)
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

	var target_pos = aim_ray.get_collision_point() + aim_ray.get_collision_normal()
	var direction = (target_pos - bullet_decal_instance.global_position).normalized()

	var up = Vector3.UP
	if abs(direction.dot(up)) > 0.99:
		up = Vector3.FORWARD  # Pick another up vector if nearly vertical

	bullet_decal_instance.look_at(target_pos, up)
	
	var timer = utils.start_and_wait_timer(self, 2.0, true)
	await timer.timeout
	bullet_decal_instance.queue_free()

func spawn_bullet_tracer(target_pos : Vector3):
	var tracer_instance = bullet_tracer.instantiate()
	get_tree().current_scene.add_child(tracer_instance)
	tracer_instance.target_pos = target_pos
	tracer_instance.global_position = muzzle_flash.global_position
	tracer_instance.look_at(target_pos)

func process_embelishments(target, hit_point):
	if target != null && target.is_in_group("enemy"):
		target.health -= damage
		emit_blood_splatter(hit_point, target)
	elif target != null:
		draw_bullet_decals(hit_point)

func spawn_bullet_casing():
	var casing_instance = bullet_casing_9mm.instantiate()
	get_tree().current_scene.add_child(casing_instance)

	# fuckass chatgpt code kill me
	var spawn_xform = bullet_casing_spawn_node.global_transform
	var basis = spawn_xform.basis.orthonormalized()
	basis = basis.rotated(basis.x, deg_to_rad(-90))  # Rotate around local X
	casing_instance.global_transform = Transform3D(basis, spawn_xform.origin)

	# EJECTION IMPULSE
	var eject_dir = basis.x.normalized()  # Right direction from the spawn node's basis
	var impulse_strength = randf_range(3.0, 5.0)
	casing_instance.apply_central_impulse(eject_dir * impulse_strength)
	# spin
	var torque = Vector3(
		randf_range(-10, 10),
		randf_range(20, 50),
		randf_range(-10, 10)
	)
	casing_instance.apply_torque_impulse(torque)

	var timer = utils.start_and_wait_timer(self, 3.0, true)
	await timer.timeout
	casing_instance.queue_free()

func _draw_debug_axes(node: Node3D):
	var origin = node.global_transform.origin
	var basis = node.global_transform.basis

	DebugDraw3D.draw_line(origin, origin + basis.x * 0.6, Color.RED)   # Right
	DebugDraw3D.draw_line(origin, origin + basis.y * 0.6, Color.GREEN) # Up
	DebugDraw3D.draw_line(origin, origin + basis.z * 0.6, Color.BLUE)  # Forward
