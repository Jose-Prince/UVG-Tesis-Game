extends Node2D

@export var isFree = true
@export var isRotated = false

var leftOffsetPos: Vector2 = Vector2(-15, 0)
var rightOffsetPos: Vector2 = Vector2(15, 0)

@onready var go_to_pos: Marker2D = $GoToPos
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.flip_h = isRotated
	if isRotated:
		go_to_pos.position = rightOffsetPos
	else:
		go_to_pos.position = leftOffsetPos
