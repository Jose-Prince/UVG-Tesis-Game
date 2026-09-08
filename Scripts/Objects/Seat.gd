class_name Seat
extends Marker2D


var occupied: bool = false
var occupant: Node = null


func is_available() -> bool:
	return not occupied


func occupy(customer: Node) -> bool:
	if occupied:
		return false
	
	occupied = true
	occupant = customer
	
	return true


func release() -> void:
	occupied = false
	occupant = null
