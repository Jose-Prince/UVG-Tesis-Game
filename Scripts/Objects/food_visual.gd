class_name FoodVisual
extends Node2D


@export var food_textures: Dictionary[String, Texture2D] = {}
@export var fallback_texture: Texture2D

var order: CustomerOrder = null


func setup(order_data: CustomerOrder) -> void:
	order = order_data

	if order == null:
		return

	update_visual()


func update_visual() -> void:
	var sprite := $Sprite2D as Sprite2D

	var texture: Texture2D = food_textures.get(
		order.item_name,
		fallback_texture
	)

	if texture == null:
		print("ERROR: No sprite for food: ", order.item_name)

	sprite.texture = texture
	sprite.visible = texture != null
