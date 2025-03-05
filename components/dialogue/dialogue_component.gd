extends Control

@onready var dialogue_component = $"."
@onready var text = $text

func _ready() -> void:
	_hide_dialogue()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire") or Input.is_action_just_pressed("interact"):
		_hide_dialogue()

func _show_dialogue(_text: String):
	global_dialogue.is_dialogue_open = true
	text.text = _text
	dialogue_component.show()

func _show_dialogue_timeout(_text: String, duration: float):
	global_dialogue.is_dialogue_open = true
	text.text = _text
	dialogue_component.show()
	await wait(duration)
	_hide_dialogue()

func _hide_dialogue():
	global_dialogue.is_dialogue_open = false
	dialogue_component.hide()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
