extends HBoxContainer

const FURNITURE_ITEM_SCENE := preload("res://Prefabs/Furniture/furniture_inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_inventory()

func update_inventory() -> void:
	_clear_inventory()
	
	for furniture_id in GameData.furniture_inventory:
		var quantity: int = GameData.furniture_inventory[furniture_id]
		
		if quantity <= 0:
			continue
		
		var furniture_data := _get_furniture_data(furniture_id)
		
		if furniture_data == null:
			continue
		
		var item = FURNITURE_ITEM_SCENE.instantiate()
		
		add_child(item)
		
		item.setup(furniture_data, quantity)

func _clear_inventory() -> void:
	for child in self.get_children():
		child.queue_free()

func _get_furniture_data(furniture_id: String) -> FurnitureData:
	for furniture in GameData.furniture_catalog:
		if furniture.id == furniture_id:
			return furniture
	return null

func _on_furniture_drag_started(furniture_data: FurnitureData) -> void:
	var furniture_manager := get_tree().get_first_node_in_group("furniture_manager")
	
	if furniture_manager:
		furniture_manager.start_furniture_placement(furniture_data)
