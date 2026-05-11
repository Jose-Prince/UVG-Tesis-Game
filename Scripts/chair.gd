extends Node2D

@export var isFree = true
@export var isRotated = false

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.flip_h = isRotated
