extends CanvasLayer

@onready var player = $"../"
@onready var ammo_counter = $in_game_gui/ammo
@onready var fps_counter = $in_game_gui/FPS
@onready var points_counter = $in_game_gui/points
@onready var interactable_message = $in_game_gui/interactable_message

var points_count : int = 0

func _ready() -> void:
	interactable_message.hide()

func _process(_delta: float) -> void:
	fps_counter.text = str("FPS %d" % Engine.get_frames_per_second())
	update_ammo_counter()
	if points_count < player.kill_count:
		points_count = player.kill_count
		update_points_counter()

func update_ammo_counter():
	ammo_counter.text = str(player.get_node("player_weapon_component").current_weapon.get_node("hitscan_weapon_component").magazine)



@export var action_scale : Vector2 = Vector2(1,1)
@export var target : Control
@export var seconds : float = 0.5
@export var properties : Array = [
	"scale",
	"position",
	"rotation",
	"size",
	"self_modulate"
]

func update_points_counter():
	points_counter.text = "points: " + str(player.kill_count)
	target.pivot_offset = target.size / 2
	var tween = get_tree().create_tween()
	for property in properties:
		tween.tween_property(target, "scale", action_scale, seconds).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
