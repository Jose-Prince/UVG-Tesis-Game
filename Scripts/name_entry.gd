extends Control

var days = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]

@onready var player_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PlayerHDisplay/PlayerEdit
@onready var shop_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/CoffeeShopHDisplay/ShopEdit
@onready var confirm_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonDisplay/ConfirmButton

func _on_confirm_button_pressed() -> void:
	var date = Time.get_datetime_dict_from_system()
	
	var start_month = date["month"] - 1
	var start_day = date["day"]
	var start_weekday = date["weekday"]
	
	SaveManager.save_especific_data(GameData.game_slot, "world", {"day": days[start_weekday], "num_day": start_day,"month": start_month, "year": 1})
	SaveManager.save_especific_data(GameData.game_slot, "player", {"name": GameData.player_name, "money": 0})
	SaveManager.save_especific_data(GameData.game_slot, "coffee_shop", {"name": GameData.shop_name})
	
	GameData.load_to_data(SaveManager.load_game(GameData.game_slot))
	
	get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")


func _on_player_edit_text_changed(new_text: String) -> void:
	GameData.player_name = new_text

func _on_shop_edit_text_changed(new_text: String) -> void:
	GameData.shop_name = new_text
