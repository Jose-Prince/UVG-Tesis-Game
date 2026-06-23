extends TextureRect

var article: Node2D

func _ready() -> void:
	article = get_tree().root.find_child("OrderObject", true, false)

	if article:
		article.object_created.connect(_on_object)
		article.object_deleted.connect(_reset_object)

func _on_object(texture: Texture2D):
	self.texture = texture

func _reset_object():
	self.texture = null
