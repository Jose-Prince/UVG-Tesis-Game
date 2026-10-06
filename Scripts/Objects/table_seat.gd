class_name TableSeat
extends Marker2D

var occupied: bool = false
var current_customer: Customer = null


func is_available() -> bool:
	return not occupied


func assign_customer(customer: Customer) -> void:
	occupied = true
	current_customer = customer

	print(
		"[SEAT] ",
		name,
		" assigned to ",
		customer.name
	)


func clear_customer() -> void:
	occupied = false
	current_customer = null

	print(
		"[SEAT] ",
		name,
		" is now available."
	)
