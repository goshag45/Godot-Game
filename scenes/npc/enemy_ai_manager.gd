extends Node3D

@export var enemy : Node3D
@export var damage_area : Area3D
@export var damage_collision : CollisionShape3D
@export var damage_timer : Timer

var player : CharacterBody3D = null
var player_in_area = false
var damage : int

func _ready() -> void:
	damage = enemy.damage
	damage_area.body_entered.connect(_on_body_entered)
	damage_area.body_exited.connect(_on_body_exited)
	damage_timer.timeout.connect(_on_damage_timer_timeout)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		player = body
		damage_timer.start()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		player = null
		damage_timer.stop()

func _on_damage_timer_timeout():
	if player_in_area and player:
		player._apply_damage(20)
