extends Node3D

@export_category("Weapon Stats")
@export var magazine_capacity = 1
@export var damage = 300
@export var fire_mode = 1
@export var shoot_sound = "rpg_shoot"
@export var reload = "reload"
@export var shoot_volume = 8

func _ready() -> void:
	$".".hide()
	pass

func _process(_delta: float) -> void:
	pass
