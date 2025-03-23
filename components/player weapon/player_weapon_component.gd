extends Node3D

@onready var player = $".."
@onready var aim_ray = $"../Head/firstperson_camera/aim_ray"

# WEAPONS
@onready var smg = $"../Head/firstperson_camera/view_model/view_model_camera/fps_rig/smg"
@onready var revolver = $"../Head/firstperson_camera/view_model/view_model_camera/fps_rig/revolver"

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

	var weapon_animation = current_weapon.get_child(2)
	if Input.is_action_just_pressed("reload"):
		weapon_animation.play("reload")
		current_weapon.get_node("hitscan_weapon_component")._reload()

	var hit_point = aim_ray.get_collision_point()
	shoot(fire_mode, hit_point)


# im sure i can clean this up
func shoot(fire_mode, hit_point):
	if (fire_mode == 1):
		if Input.is_action_just_pressed("fire"):
			var target
			if aim_ray.is_colliding():
				target = aim_ray.get_collider()
			player.get_node("player_weapon_component").current_weapon.get_node("hitscan_weapon_component")._shoot(target, hit_point)
	
	if (fire_mode == 2):
		if Input.is_action_pressed("fire"):
			var target
			if aim_ray.is_colliding():
				target = aim_ray.get_collider()
			player.get_node("player_weapon_component").current_weapon.get_node("hitscan_weapon_component")._shoot(target, hit_point)
