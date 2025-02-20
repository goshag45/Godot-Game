extends Control

@onready var dialogue_component = $"."
@onready var text = $text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		dialogue_component.hide()

func _showdialogue(_text: String):
	text.text = _text
	dialogue_component.show()
