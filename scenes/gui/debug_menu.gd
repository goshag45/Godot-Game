extends Control

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var speedometer = $speedometer
@onready var balls_counter = $balls

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	update_speedometer()
	update_orb_counter()

func update_speedometer():
	var speed = player.velocity.length()
	var trim = snapped(speed, 0.01)
	speedometer.text = str(trim)

func update_orb_counter():
	if player.get_tree().root.get_node("level_2"):
		balls_counter.text = "BALLS: " + str(player.get_tree().root.get_node("level_2").get_node("enemy_manager").gore_ball_counter)
