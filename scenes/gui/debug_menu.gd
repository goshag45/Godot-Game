extends Control

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var speedometer = $speedometer

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	update_speedometer()

func update_speedometer():
	var speed = player.velocity.length()
	var trim = snapped(speed, 0.01)
	speedometer.text = str(trim)
