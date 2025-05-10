extends Node3D

@export_category("Weapon Stats")
@export var magazine_capacity = 2
@export var damage = 34 #PER PELLET
@export var fire_mode = 1
@export var shoot_sound = "shotgun_shoot"
@export var reload = "reload"
@export var shoot_volume = 8

@export var pellet_count: int = 9
@export var spread_angle_degrees: float = 4.0

func _ready() -> void:
	$".".hide()

func _process(_delta: float) -> void:
	pass
