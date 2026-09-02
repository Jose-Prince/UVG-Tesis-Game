class_name Teleport
extends Area2D

@export var teleport_id = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		TeleportManager.teleport(teleport_id)
