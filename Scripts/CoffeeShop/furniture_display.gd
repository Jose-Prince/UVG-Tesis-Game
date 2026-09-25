extends HBoxContainer

const FURNITURE_ITEM_SCENE := preload(
	"res://Prefabs/Furniture/furniture_inventory_item.tscn"
)


func _ready() -> void:
	update_inventory()


func update_inventory() -> void:
	_clear_inventory()

	for furniture_id in FurnitureDatabase.furniture_inventory:
		var quantity: int = FurnitureDatabase.furniture_inventory[furniture_id]

		if quantity <= 0:
			continue

		var furniture_data := _get_furniture_data(furniture_id)

		if furniture_data == null:
			continue

		var item := FURNITURE_ITEM_SCENE.instantiate()

		add_child(item)

		item.setup(furniture_data, quantity)


func _clear_inventory() -> void:
	for child in get_children():
		child.queue_free()


func _get_furniture_data(furniture_id: String) -> FurnitureData:
	for furniture in FurnitureDatabase.furniture_catalog:
		if furniture.id == furniture_id:
			return furniture

	return null
