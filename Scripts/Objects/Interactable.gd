class_name Interactable
extends Area2D


signal interacted(player)


func interact(player: Player) -> void:
	interacted.emit(player)
