extends Node2D

signal object_created(texture: Texture2D)
	
func _on_child_entered_tree(node: Node) -> void:
	var sprite := node.find_child("Sprite2D", true, false)

	if sprite is Sprite2D:
		object_created.emit(sprite.texture)
