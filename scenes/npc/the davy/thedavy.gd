extends CharacterBody3D

@onready var player = null
@onready var thedavy = $"."
@onready var audio_component = $audio_component
@onready var dialogue_component = $dialogue_component

signal talk
signal da_aura

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	player = players[0]
	if player:
		#players = get_tree().get_nodes_in_group("player")
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0  # Prevent tilting by locking the Y-axis
		look_at(global_transform.origin - direction, Vector3.UP)

func interact():
	audio_component._play_audio_sfx("as_you_wish", 15.0, false)
	dialogue_component._show_dialogue_timeout("as you wish", 1.5)
	talk.emit()
	da_aura.emit()
