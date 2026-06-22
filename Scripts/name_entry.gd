extends Control

@export var initial_menu: Array[ArticleData] = []

@onready var player_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PlayerHDisplay/PlayerEdit
@onready var shop_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/CoffeeShopHDisplay/ShopEdit
@onready var confirm_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonDisplay/ConfirmButton

func _ready() -> void:
	GameData.menu = initial_menu

	GameData.menu_ids.clear()

	for article in initial_menu:
		GameData.menu_ids.append(article.id)

func _on_confirm_button_pressed() -> void:
	randomize()
	var date = Time.get_datetime_dict_from_system()
	
	var start_month = date["month"] - 1
	var start_day = date["day"]
	
	SaveManager.save_especific_data(GameData.game_slot, "world", {"day_index": randi_range(0, 6), "num_day": start_day,"month": start_month, "year": 1})
	SaveManager.save_especific_data(GameData.game_slot, "player", {"name": GameData.player_name, "money": 0, "popularity": 0})
	SaveManager.save_especific_data(GameData.game_slot, "coffee_shop", {"name": GameData.shop_name, "menu_ids": GameData.menu_ids})
	
	GameData.load_to_data(SaveManager.load_game(GameData.game_slot))
	
	get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")

func _on_player_edit_text_changed(new_text: String) -> void:
	GameData.player_name = new_text

func _on_shop_edit_text_changed(new_text: String) -> void:
	GameData.shop_name = new_text
