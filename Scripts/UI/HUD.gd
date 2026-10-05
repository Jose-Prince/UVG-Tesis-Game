extends CanvasLayer


@onready var money_label: Label = $MoneyLabel
@onready var time_label: Label = $TimeLabel


func _process(_delta: float) -> void:
	update_money_display()
	update_time_display()


func update_money_display() -> void:
	var economy := get_tree().get_first_node_in_group("cafe_economy") as CafeEconomy

	if economy == null:
		return

	money_label.text = "Money: $%.2f" % economy.get_money()


func update_time_display() -> void:
	var day_manager := get_tree().get_first_node_in_group("cafe_day_manager") as CafeDayManager

	if day_manager == null:
		return

	time_label.text = "Day %d - %s" % [
		day_manager.get_current_day(),
		day_manager.get_time_string()
	]


func _on_build_button_pressed() -> void:
	$FurniturePlacementUi.show_ui()
