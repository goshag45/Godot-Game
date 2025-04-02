extends Node3D

@export_category("Weapon Stats")
@export var magazine_capacity = 20
@export var damage = 20
@export var fire_mode = 2
@export var shoot_sound = "smg_shoot"
@export var reload = "reload"
@export var shoot_volume = 1

func _ready() -> void:
	$".".hide()
	pass

func _process(_delta: float) -> void:
	pass
