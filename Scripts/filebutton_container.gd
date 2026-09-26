extends VBoxContainer

const LOAD_BUTTON_PREFAB := preload("res://Prefabs/load_button.tscn")

var load_buttons: Array[Button] = []

@onready var back_button: Button = $"../../../../../HBoxContainer/BackButton"


func _ready() -> void:
	var save_slots := SaveManager.get_save_slots()
	
	if save_slots.is_empty():
		get_tree().change_scene_to_file("res://Scenes/UI/title_screen.tscn")
		return
	
	for slot in save_slots:
		var save_data := SaveManager.read_save_data(slot)
		
		if save_data.is_empty():
			continue
		
		var player_data: Dictionary = save_data.get("player", {})
		var shop_data: Dictionary = save_data.get("coffee_shop", {})
		var world_data: Dictionary = save_data.get("world", {})
		
		var player_name := str(player_data.get("name", ""))
		var money := int(player_data.get("money", 0))
		
		var shop_name := str(shop_data.get("name", ""))
		
		var day_index := int(world_data.get("day_index", 0))
		var num_day := int(world_data.get("num_day", 1))
		var month := int(world_data.get("month", 1))
		var year := int(world_data.get("year", 1))
		
		var appearance = player_data.get("appearance", {})
		
		var button := LOAD_BUTTON_PREFAB.instantiate()
		add_child(button)
		
		load_buttons.append(button)
		
		button.setup(
			slot,
			player_name,
			shop_name,
			money,
			day_index,
			num_day,
			month,
			year,
			appearance
		)
		
		button.pressed.connect(
			_on_save_button_pressed.bind(slot)
		)
	
	_setup_focus()


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
	var success := SaveManager.load_game(slot)
	
	if not success:
		push_error("Failed to load save slot: %d" % slot)
		return
	
	GameData.game_slot = slot
	
	get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/title_screen.tscn")


func _on_back_button_mouse_entered() -> void:
	back_button.grab_focus()
