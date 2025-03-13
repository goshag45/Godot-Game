extends CharacterBody3D

@onready var player = null
@onready var thedavy = $"."
@onready var audio_component = $audio_component
@onready var dialogue_component = $dialogue_component

signal talk()

#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	player = players[0]
	if player:
		#players = get_tree().get_nodes_in_group("player")
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0  # Prevent tilting by locking the Y-axis
		look_at(global_transform.origin - direction, Vector3.UP)

func interact():
	audio_component._play_audio_sfx("icanseeyou", 10.0)
	dialogue_component._show_dialogue("i can see you")
	talk.emit()
