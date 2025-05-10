extends Node3D

@onready var player = $".."
@onready var aim_ray = $"../head/firstperson_camera/aim_ray"

# WEAPONS
@onready var smg = $"../head/firstperson_camera/view_model/view_model_camera/fps_rig/smg"
@onready var revolver = $"../head/firstperson_camera/view_model/view_model_camera/fps_rig/revolver"
@onready var shotgun = $"../head/firstperson_camera/view_model/view_model_camera/fps_rig/winchesta"
@onready var rpg = $"../head/firstperson_camera/view_model/view_model_camera/fps_rig/rpg"

@onready var current_weapon = smg

func _ready() -> void:
	current_weapon.show()

func _process(_delta: float) -> void:
	# 1 = semi auto
	# 2 = full auto
	var fire_mode = current_weapon.fire_mode

	if (Input.is_action_just_pressed("num1")):
		current_weapon.hide()
		current_weapon = smg
		smg.show()
	if (Input.is_action_just_pressed("num2")):
		current_weapon.hide()
		current_weapon = revolver
		revolver.show()
	if (Input.is_action_just_pressed("num3")):
		current_weapon.hide()
		current_weapon = shotgun
		shotgun.show()
	if (Input.is_action_just_pressed("num4")):
		current_weapon.hide()
		current_weapon = rpg
		rpg.show()

	var weapon_animation = current_weapon.find_child("animation")
	if Input.is_action_just_pressed("reload"):
		weapon_animation.stop()
		weapon_animation.play("reload")
		var weapon_component = utils.get_child_in_group(current_weapon, "weapon_component")
		weapon_component.reload()

	var hit_point = aim_ray.get_collision_point()
	if !aim_ray.is_colliding():
		hit_point = aim_ray.global_transform * aim_ray.target_position
	shoot(fire_mode, hit_point)

# im sure i can clean this up
func shoot(fire_mode: int, hit_point: Vector3) -> void:
	var should_fire := (
		(fire_mode == 1 and Input.is_action_just_pressed("fire")) or
		(fire_mode == 2 and Input.is_action_pressed("fire"))
	)

	if not should_fire:
		return

	current_weapon = player.get_node("player_weapon_component").current_weapon
	if current_weapon == null:
		print("No current weapon equipped")
		return

	var weapon_component = utils.get_child_in_group(current_weapon, "weapon_component")
	var is_hitscan = false
	is_hitscan = current_weapon.is_in_group("hitscan")
	if !is_hitscan:
		weapon_component.shoot()
		return

	var target = null
	if is_hitscan and aim_ray.is_colliding():
		target = aim_ray.get_collider()

	if current_weapon.name == "winchesta":
		weapon_component.shoot_with_spread()
	else:
		weapon_component.shoot(target, hit_point)
