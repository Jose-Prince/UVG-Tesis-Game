extends VBoxContainer

const SHOP_ITEM_SCENE := preload("res://Prefabs/Shop/item.tscn")

@onready var shop_items: Control = $"../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in FurnitureDatabase.furniture_catalog:
		var shop_item = SHOP_ITEM_SCENE.instantiate()
		add_child(shop_item)
		shop_item.setup(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not shop_items.visible:
		return
	
	TimeSystem.pause_time()
