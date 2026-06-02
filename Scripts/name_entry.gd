extends Control

@onready var player_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PlayerHDisplay/PlayerEdit
@onready var shop_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/CoffeeShopHDisplay/ShopEdit
@onready var confirm_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonDisplay/ConfirmButton

func _on_confirm_button_pressed() -> void:
	GameData.player_name = player_edit.text
	GameData.shop_name = shop_edit.text
	
	get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")
