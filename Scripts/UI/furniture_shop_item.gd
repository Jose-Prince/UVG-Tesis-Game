class_name FurnitureShopItem
extends PanelContainer


signal purchase_requested(item_id: String)


@export var item_id: String = ""
@export var item_name: String = ""
@export var price: int = 0
@export var preview_color: Color = Color.WHITE


@onready var item_preview: Control = $MarginContainer/VBoxContainer/ItemPreview
@onready var preview_color_rect: ColorRect = $MarginContainer/VBoxContainer/ItemPreview/ColorRect
@onready var item_name_label: Label = $MarginContainer/VBoxContainer/ItemName
@onready var price_label: Label = $MarginContainer/VBoxContainer/PriceLabel
@onready var buy_button: Button = $MarginContainer/VBoxContainer/BuyButton


func _ready() -> void:
	setup_item()


func setup_item() -> void:
	item_name_label.text = item_name
	price_label.text = "$" + str(price)

	preview_color_rect.color = preview_color

	buy_button.pressed.connect(_on_buy_pressed)


func _on_buy_pressed() -> void:
	purchase_requested.emit(item_id)
