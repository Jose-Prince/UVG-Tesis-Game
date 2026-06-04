extends Button

@onready var player_label: Label = $MarginContainer/GridContainer/PlayerLabel
@onready var shop_label: Label = $MarginContainer/GridContainer/ShopLabel
@onready var money_label: Label = $MarginContainer/GridContainer/MoneyLabel
@onready var date_label: Label = $MarginContainer/GridContainer/DateLabel

func setup(
	player_name: String,
	shop_name: String,
	money: int,
	day: String,
	day_number: int,
	month: String,
	year: int
) -> void:
	player_label.text = "%s" % player_name
	shop_label.text = "Coffee Shop: %s" % shop_name
	money_label.text = "Money: $%d" % money
	date_label.text = "%s %s, %s, %d" % [day, day_number,month, year]
