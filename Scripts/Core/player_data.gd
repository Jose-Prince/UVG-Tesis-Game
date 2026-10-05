extends Node


var money: float = 0.0


func add_money(amount: float) -> void:
	if amount <= 0:
		return

	money += amount

	print("Money added: $", amount)
	print("Current money: $", money)


func can_afford(amount: float) -> bool:
	return money >= amount


func spend_money(amount: float) -> bool:
	if amount <= 0:
		return false

	if money < amount:
		return false

	money -= amount

	print("Money spent: $", amount)
	print("Current money: $", money)

	return true
