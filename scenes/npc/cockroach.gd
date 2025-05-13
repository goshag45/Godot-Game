extends CharacterBody3D

@export var health = 300
@export var blood_color : Color = Color.FLORAL_WHITE
@export var audio_component : Node3D

@onready var player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if health <= 0:
		die()

func die():
	global_signals.cockroach_died.emit()
	#make this a bug squash sound
	audio_component._play_audio_sfx("fart", 3)
	queue_free()
