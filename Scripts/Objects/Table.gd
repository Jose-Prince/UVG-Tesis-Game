class_name Table
extends Interactable


enum TableState {
	AVAILABLE,
	RESERVED,
	OCCUPIED
}


var state: TableState = TableState.AVAILABLE


func interact(player: Player) -> void:
	print("Interacted with table: ", name)
	print("State: ", get_state_name())


func get_state_name() -> String:
	match state:
		TableState.AVAILABLE:
			return "Available"

		TableState.RESERVED:
			return "Reserved"

		TableState.OCCUPIED:
			return "Occupied"

	return "Unknown"
