extends Node3D

var magazine = 6
@export var magazine_capacity = 6
@export var damage = 50

@onready var revolver = $"."
@onready var animation = $animation
@onready var muzzle_flash = $muzzle_flash
@onready var audio_component = $audio_component

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
