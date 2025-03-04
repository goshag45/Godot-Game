extends CanvasLayer

@onready var player = $"../"
@onready var ammo_counter = $in_game_gui/ammo
@onready var fps_counter = $in_game_gui/FPS
@onready var interactable_message = $in_game_gui/interactable_message

func _ready() -> void:
	interactable_message.hide()

func _process(_delta: float) -> void:
	ammo_counter.text = str(player.get_node("player_weapon_component").current_weapon.get_node("hitscan_weapon_component").magazine)
	fps_counter.text = str("FPS %d" % Engine.get_frames_per_second())
