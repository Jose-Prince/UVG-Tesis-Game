extends Button

@onready var price_label: Label = $MarginContainer/HBoxContainer/ItemPrice/PriceLabel

@export var price: float = 25.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if GameData.money < price:
		return
	
	GameData.money -= price
	
	SfxManager.play_money()
