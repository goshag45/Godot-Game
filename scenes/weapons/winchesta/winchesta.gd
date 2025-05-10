extends Node3D

@export_category("Weapon Stats")
@export var magazine_capacity = 2
@export var damage = 100
@export var fire_mode = 1
@export var shoot_sound = "shotgun_shoot"
@export var reload = "reload"
@export var shoot_volume = 8

@export var pellet_count: int = 9
@export var pellet_grid_size: int = 3
@export var pellet_spacing: float = 0.025

func _ready() -> void:
	$".".hide()
	pass

func _process(_delta: float) -> void:
	pass
