extends Button

var days = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "Decemmber"]
var slot: int

@onready var player_label: Label = $MarginContainer/HBoxContainer/GridContainer/PlayerLabel
@onready var shop_label: Label = $MarginContainer/HBoxContainer/GridContainer/ShopLabel
@onready var money_label: Label = $MarginContainer/HBoxContainer/GridContainer/MoneyLabel
@onready var date_label: Label = $MarginContainer/HBoxContainer/GridContainer/DateLabel

@onready var delete_file_button: Button = $MarginContainer/HBoxContainer/DeleteFileButton

func setup(
	save_slot: int,
	player_name: String,
	shop_name: String,
	money: int,
	day_index: int,
	num_day: int,
	month: int,
	year: int
) -> void:
	slot = save_slot
	var month_name: String = months[month]
	var day = days[day_index]
	
	player_label.text = "%s" % player_name
	shop_label.text = "Coffee Shop: %s" % shop_name
	money_label.text = "Money: $%d" % money
	date_label.text = "%s %d, %s, Year %d" % [day, num_day ,month_name, year]

func _on_delete_file_button_pressed() -> void:
	SaveManager.delete_save(slot)

	get_tree().reload_current_scene()
