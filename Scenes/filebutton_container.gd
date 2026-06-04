extends VBoxContainer

const LOAD_BUTTON_PREFAB := preload("res://Prefabs/load_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var max_slot = SaveManager.get_save_count()
	
	for slot in range(0, max_slot + 1):
		if SaveManager.save_exists(slot):
			var save_data = SaveManager.load_game(slot)

			var player_name = save_data["player"]["name"]
			var money = save_data["player"]["money"]

			var shop_name = save_data["coffee_shop"]["name"]

			var day = save_data["world"]["day"]
			var num_day = save_data["world"]["num_day"]
			var month = save_data["world"]["month"]
			var year = save_data["world"]["year"]

			var button := LOAD_BUTTON_PREFAB.instantiate()
			add_child(button)

			button.setup(
				player_name,
				shop_name,
				money,
				day,
				num_day,
				month,
				year
			)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
