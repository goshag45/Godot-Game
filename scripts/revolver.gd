extends Node3D

@onready var gun_barrel = $FPSRig/Revolver/gun_barrel
@export var revolver_gunshot = preload("res://audio/revolver_gunshot.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
