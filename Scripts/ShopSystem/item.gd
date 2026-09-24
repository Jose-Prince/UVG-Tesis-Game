extends Button

var furniture_data: FurnitureData
var price: float

@onready var price_label: Label = $MarginContainer/HBoxContainer/ItemPrice/PriceLabel
@onready var name_label: Label = $MarginContainer/HBoxContainer/ItemDetails/NameLabel
@onready var object_texture: TextureRect = $MarginContainer/HBoxContainer/ItemDetails/ObjectTexture
 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(data: FurnitureData) -> void:
	if data == null:
		push_error("Item setup received null FurnitureData.")
		return
	
	furniture_data = data
	price = data.price
	
	name_label.text = data.display_name
	price_label.text = str(data.price)
	object_texture.texture = data.icon

func _on_pressed() -> void:
	if furniture_data == null:
		return
	
	if GameData.money < price:
		return
	
	GameData.money -= price
	FurnitureDatabase.furniture_inventory[furniture_data.id] = (
		FurnitureDatabase.furniture_inventory.get(furniture_data.id, 0) + 1
	)
	
	SfxManager.play_money()
