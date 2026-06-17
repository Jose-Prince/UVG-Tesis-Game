extends NinePatchRect

var article: Node2D

func _ready() -> void:
	article = get_tree().root.find_child("OrderObject", true, false)

	if article:
		article.object_created.connect(_on_object)

func _on_object(texture: Texture2D):
	self.texture = texture
