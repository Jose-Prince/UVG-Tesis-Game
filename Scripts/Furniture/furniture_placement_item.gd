class_name FurniturePlacementItem
extends PanelContainer

signal place_requested(item_id: String)

@export var item_id: String = ""
@export var item_name: String = ""

@onready var item_name_label: Label = $MarginContainer/HBoxContainer/Info/ItemName
@onready var quantity_label: Label = $MarginContainer/HBoxContainer/Info/QuantityLabel
@onready var place_button: Button = $MarginContainer/HBoxContainer/PlaceButton


func _ready() -> void:
	place_button.pressed.connect(_on_place_pressed)
	update_item()


func update_item() -> void:
	item_name_label.text = item_name

	var quantity := FurnitureInventory.get_item_count(item_id)
	quantity_label.text = "Owned: " + str(quantity)

	place_button.disabled = quantity <= 0


func _on_place_pressed() -> void:
	if item_id.is_empty():
		return

	if not FurnitureInventory.has_item(item_id):
		update_item()
		return

	place_requested.emit(item_id)
