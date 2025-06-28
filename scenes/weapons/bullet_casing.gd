extends RigidBody3D

@export var audio_component: Node3D
var casing_sounds = ["light_shell_1","light_shell_2","light_shell_3","light_shell_4","light_shell_5","light_shell_6"]

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	body_shape_entered.connect(_on_body_hit)

func _on_body_hit(body_id, body, body_shape_index, local_shape_index):
	print("Casing hit something:", body)
	audio_component._play_random_sfx(casing_sounds, 3)
	body_shape_entered.disconnect(_on_body_hit) # Optional: Only play once
