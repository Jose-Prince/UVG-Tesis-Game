extends Node

const WOODEN_TABLE: FurnitureData = preload("res://Resources/Furniture/WoodenTable.tres")
const WOODEN_CHAIR: FurnitureData = preload("res://Resources/Furniture/WoodenChair.tres")

var furniture_catalog: Array[FurnitureData] = [WOODEN_TABLE, WOODEN_CHAIR]

var furniture_inventory: Dictionary = {
	"wooden_table": 1,
	"wooden_chair": 1
}

var placed_furniture: Array[Dictionary] =  []
