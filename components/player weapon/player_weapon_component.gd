extends Node3D

@onready var aim_ray = $Head/firstperson_camera/aim_ray

# WEAPONS
@onready var smg = $Head/firstperson_camera/sub_viewport_container/sub_viewport/ViewModelCamera/FPSRig/smg
@onready var revolver = $Head/firstperson_camera/sub_viewport_container/sub_viewport/ViewModelCamera/FPSRig/revolver

@onready var current_weapon = smg

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("num1")):
		current_weapon.hide()
		current_weapon = smg
		smg.show()
	if (Input.is_action_just_pressed("num2")):
		current_weapon.hide()
		current_weapon = revolver
		revolver.show()

	var weapon_animation = current_weapon.get_child(2)
	if Input.is_action_just_pressed("reload"):
		weapon_animation.play("reload")
		current_weapon._reload()

	var weapon_name = current_weapon.name
	var hit_point = aim_ray.get_collision_point()
	if Input.is_action_pressed("fire"):
		var target
		if aim_ray.is_colliding():
			target = aim_ray.get_collider()
		_shoot_gun(weapon_name, target, hit_point)

func _shoot_gun(gun, target, hit_point):
	match gun:
		"smg":
			smg._shoot(target, hit_point)
		"revolver":
			pass
