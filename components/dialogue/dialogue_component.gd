extends Control

@onready var dialogue_component = $"."
@onready var text = $text

func _ready() -> void:
	dialogue_component.hide()
	pass 

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		dialogue_component.hide()

func _show_dialogue(_text: String):
	text.text = _text
	dialogue_component.show()

func _show_dialogue_timeout(_text: String, duration: float):
	text.text = _text
	dialogue_component.show()
	await wait(duration)
	dialogue_component.hide()

func _hide_dialogue():
	dialogue_component.hide()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
