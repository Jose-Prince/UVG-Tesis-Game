extends Node2D

signal object_created(texture: Texture2D)
signal object_deleted

func _check_empty():
	if get_child_count() == 0:
		object_deleted.emit()

func _on_child_entered_tree(node: Node) -> void:
	var sprite := node.find_child("Sprite2D", true, false)

	if sprite is Sprite2D:
		object_created.emit(sprite.texture)

func _on_child_exiting_tree(node: Node) -> void:
	call_deferred("_check_empty")
