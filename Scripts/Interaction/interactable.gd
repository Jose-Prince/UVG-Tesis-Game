class_name Interactable
extends StaticBody2D


func _ready() -> void:
	add_to_group("interactable")


func interact() -> void:
	print("Interacted with: ", name)
