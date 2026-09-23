class_name Interactable
extends StaticBody2D


@export var interaction_radius: float = 50.0


func _ready() -> void:
	add_to_group("interactable")


func get_interaction_position() -> Vector2:
	return global_position


func interact() -> void:
	print("Interacted with: ", name)
