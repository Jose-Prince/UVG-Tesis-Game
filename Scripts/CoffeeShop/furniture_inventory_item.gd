extends Control

var furniture_data: FurnitureData

@onready var furniture_button: Button = $FurnitureButton
@onready var quantity_label: Label = $QuantityLabel


func setup(data: FurnitureData, quantity: int) -> void:
	furniture_data = data
	furniture_button.icon = data.icon
	quantity_label.text = str(quantity)


func _process(_delta: float) -> void:
	if furniture_data == null:
		return

	if Input.is_action_just_pressed("mouse_action"):
		var mouse_position := get_viewport().get_mouse_position()

		if get_global_rect().has_point(mouse_position):
			var furniture_manager := get_tree().get_first_node_in_group(
				"furniture_manager"
			) as FurnitureManager

			if furniture_manager:
				print("STARTING FURNITURE DRAG: ", furniture_data.id)
				furniture_manager.start_furniture_placement(furniture_data)
