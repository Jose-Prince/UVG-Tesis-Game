extends Control

@onready var player_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PlayerHDisplay/PlayerEdit
@onready var shop_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/CoffeeShopHDisplay/ShopEdit
@onready var confirm_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonDisplay/ConfirmButton

func _ready() -> void:
	print(player_edit)

func _on_confirm_button_pressed() -> void:
	SaveManager.save_especific_data(1, "player", {"name": GameData.player_name, "money": 0})
	SaveManager.save_especific_data(1, "coffee_shop", {"name": GameData.shop_name})
	
	#get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")


func _on_player_edit_text_changed(new_text: String) -> void:
	GameData.player_name = new_text

func _on_shop_edit_text_changed(new_text: String) -> void:
	GameData.shop_name = new_text
