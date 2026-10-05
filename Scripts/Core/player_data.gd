extends Node


var money: float = 500.0


func add_money(amount: float) -> void:
	if amount <= 0:
		return

	var previous_money := money

	money += amount

	print(
		"[MONEY] +$",
		amount,
		" | ",
		previous_money,
		" → ",
		money
	)


func can_afford(amount: float) -> bool:
	return money >= amount


func spend_money(amount: float) -> bool:
	if amount <= 0:
		return false

	if money < amount:
		print(
			"[MONEY] Purchase rejected | Cost: $",
			amount,
			" | Current: $",
			money
		)

		return false

	var previous_money := money

	money -= amount

	print(
		"[MONEY] -$",
		amount,
		" | ",
		previous_money,
		" → ",
		money
	)

	return true
