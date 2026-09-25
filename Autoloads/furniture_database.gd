extends Node

const WOODEN_TABLE: FurnitureData = preload("res://Resources/Furniture/WoodenTable.tres")
const WOODEN_CHAIR: FurnitureData = preload("res://Resources/Furniture/WoodenChair.tres")

var furniture_catalog: Array[FurnitureData] = [WOODEN_TABLE, WOODEN_CHAIR]

var furniture_inventory: Dictionary = {
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
