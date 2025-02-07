extends CharacterBody3D

@onready var player = null
@onready var thedavy = $"."
@onready var audio_component = $audio_component
@onready var dialogue_component = $dialogue_component

signal talk()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players == null:
		print("Player node not found!")
	else:
		player = players[0]
		print(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player:
		thedavy.look_at(player.global_position)
	pass

func interact():
	audio_component._play_audio_sfx("icanseeyou", 10.0)
	dialogue_component._showdialogue("i can see you")
	talk.emit()
	pass
