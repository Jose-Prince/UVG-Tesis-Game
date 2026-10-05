class_name FurniturePlacementUI
extends Control

@export var furniture_item_scene: PackedScene

@onready var furniture_list: VBoxContainer = $Panel/MarginContainer/VBoxContainer/FurnitureScroll/FurnitureList
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/Header/CloseButton
@onready var remove_button: Button = $Panel/MarginContainer/VBoxContainer/RemoveButton

func _ready() -> void:
	hide()

	close_button.pressed.connect(hide_ui)

	FurnitureInventory.inventory_changed.connect(_on_inventory_changed)

	build_furniture_list()


func show_ui() -> void:
	build_furniture_list()
	show()


func hide_ui() -> void:
	hide()


func build_furniture_list() -> void:
	for child in furniture_list.get_children():
		child.queue_free()

	var items := FurnitureInventory.get_items()

	for item_id in items:
		var item := furniture_item_scene.instantiate() as FurniturePlacementItem

		item.item_id = item_id
		item.item_name = get_item_name(item_id)

		furniture_list.add_child(item)

		item.place_requested.connect(_on_place_requested)


func _on_place_requested(item_id: String) -> void:
	print("[PLACEMENT UI] Placing: ", item_id)

	hide_ui()

	FurniturePlacementManager.start_placement(item_id)


func _on_inventory_changed() -> void:
	if visible:
		build_furniture_list()


func get_item_name(item_id: String) -> String:
	match item_id:
		"wooden_table":
			return "Wooden Table"

		"wooden_chair":
			return "Wooden Chair"

	return item_id


func _on_remove_button_pressed() -> void:
	hide_ui()
	FurniturePlacementManager.start_removal()
