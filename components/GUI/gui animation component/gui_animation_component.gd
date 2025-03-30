class_name GuiAnimationComponent extends Node

@export_group("Options")
@export var from_center : bool = true
@export var parallel_animations : bool = true
@export var properties : Array = [
	"scale",
	"position",
	"rotation",
	"size",
	"self_modulate"
]

@export_group("Action Settings")
@export var action_time : float = 0.1
@export var action_transition : Tween.TransitionType
@export var action_easing : Tween.EaseType
@export var action_position : Vector2
@export var action_scale : Vector2 = Vector2(1,1)
@export var action_rotation : float
@export var action_size : Vector2
@export var action_modulate : Color = Color.WHITE

var target : Control
var default_scale : Vector2
var action_values : Dictionary
var default_values : Dictionary

func _ready() -> void:
	target = get_parent()
	call_deferred("setup")

func connect_signals() -> void:
	target.action.connect(add_tween.bind(
			action_values,
			parallel_animations,
			action_time,
			action_transition,
			action_easing
		)
	)

func setup() -> void:
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale
	default_values = {
		"scale": target.scale,
		"position": target.position,
		"rotation":target.rotation,
		"size": target.size,
		"self_modulate": target.modulate
	}
	action_values = {
		"scale": action_scale,
		"position": target.position + action_position,
		"rotation":target.rotation + deg_to_rad(action_rotation),
		"size": target.size + action_size,
		"self_modulate": action_modulate
	}
#	connect_signals()

func add_tween(values: Dictionary, parallel: bool, seconds: float, transition: Tween.TransitionType, easing: Tween.EaseType) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(parallel)
	print("added tween")
	for property in properties:
		tween.tween_property(target, property, values, seconds).set_trans(transition).set_ease(easing)


# https://www.youtube.com/watch?v=3lJqkn6nD0o
