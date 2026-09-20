extends Control

@onready var furniture_button: Button = $FurnitureButton
@onready var quantity_label: Label = $QuantityLabel

func setup(furniture_data: FurnitureData, quantity: int) -> void:
	furniture_button.icon = furniture_data.icon
	quantity_label.text = str(quantity)
