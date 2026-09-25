extends Control

var furniture_data: FurnitureData

@onready var furniture_button: Button = $FurnitureButton
@onready var quantity_label: Label = $QuantityLabel


func setup(data: FurnitureData, quantity: int) -> void:
	furniture_data = data

	furniture_button.icon = data.icon
	quantity_label.text = str(quantity)


func _on_furniture_button_pressed() -> void:
	if furniture_data == null:
		return

	var furniture_manager := get_tree().get_first_node_in_group(
		"furniture_manager"
	) as FurnitureManager

	if furniture_manager == null:
		push_error("FurnitureManager not found.")
		return

	print("CLICKED FURNITURE BUTTON: ", furniture_data.id)

	furniture_manager.start_furniture_placement(furniture_data)
