extends VBoxContainer

const LOAD_BUTTON_PREFAB := preload("res://Prefabs/load_button.tscn")

var load_buttons: Array[Button] = []

@onready var back_button: Button = $"../../../../../HBoxContainer/BackButton"

func _ready() -> void:
	var max_slot = SaveManager.get_save_count()
	
	if max_slot <= 0:
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	
	for slot in range(0, max_slot + 1):
		if SaveManager.save_exists(slot):
			var save_data = SaveManager.load_game(slot)

			var player_name = save_data["player"]["name"]
			var money = save_data["player"]["money"]

			var shop_name = save_data["coffee_shop"]["name"]

			var day_index = save_data["world"]["day_index"]
			var num_day = save_data["world"]["num_day"]
			var month = save_data["world"]["month"]
			var year = save_data["world"]["year"]

			var button := LOAD_BUTTON_PREFAB.instantiate()
			add_child(button)
			
			load_buttons.append(button)
			
			button.setup(
				slot,
				str(player_name),
				str(shop_name),
				int(money),
				int(day_index),
				int(num_day),
				int(month),
				int(year)
			)
			
			button.pressed.connect(
				_on_save_button_pressed.bind(slot)
			)
			
	#_setup_focus()

func _setup_focus() -> void:
	if load_buttons.is_empty():
		return
	
	load_buttons[0].grab_focus()
	
	for i in load_buttons.size():
		var button := load_buttons[i]
		
		if i == 0:
			button.focus_neighbor_top = back_button.get_path()
		else:
			button.focus_neighbor_top = load_buttons[i - 1].get_path()
		
		if i == load_buttons.size() - 1:
			button.focus_neighbor_bottom = back_button.get_path()
		else:
			button.focus_neighbor_bottom = load_buttons[i + 1].get_path()
			
	back_button.focus_neighbor_top = load_buttons.back().get_path()
	back_button.focus_neighbor_bottom = load_buttons[0].get_path()

func _on_save_button_pressed(slot: int) -> void:
	var save_data = SaveManager.load_game(slot)

	GameData.game_slot = slot
	GameData.load_to_data(save_data)

	get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
