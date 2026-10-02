class_name CafeEconomy
extends Node


var money: float = 0.0

func _ready() -> void:
	add_to_group("cafe_economy")

func add_money(amount: float) -> void:
	if amount <= 0.0:
		return

	money += amount

	print(
		"Money earned: $",
		amount,
		" | Total money: $",
		money
	)


func get_money() -> float:
	return money
