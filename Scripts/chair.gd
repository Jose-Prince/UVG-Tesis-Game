extends Node2D

@export var isFree = true
@export var isRotated = false

var leftOffsetPos: Vector2 = Vector2(-20, 0)
var rightOffsetPos: Vector2 = Vector2(20, 0)

var assigned_table: StaticBody2D

var sit_offset: Vector2 = Vector2(0, -6)  # tweak Y to center on the chair sprite

@onready var go_to_pos: Marker2D = $GoToPos
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.flip_h = isRotated
	if isRotated:
		go_to_pos.position = rightOffsetPos
	else:
		go_to_pos.position = leftOffsetPos

func _process(delta: float) -> void:
	z_index = int(global_position.y)

func assign_table(table):
	assigned_table = table
	
func get_sit_position() -> Vector2:
	return global_position + sit_offset
