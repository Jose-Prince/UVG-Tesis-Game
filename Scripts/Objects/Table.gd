class_name Table
extends Interactable


enum TableState {
	AVAILABLE,
	RESERVED,
	OCCUPIED
}


var state: TableState = TableState.AVAILABLE


@onready var seats: Array[Seat] = [$SeatTop, $SeatDown, $SeatLeft, $SeatRight]

func _ready() -> void:
	add_to_group("interactable")
	add_to_group("tables")
	
	for child in get_children():
		if child is Seat:
			seats.append(child)

func interact(player: Player) -> void:
	print("========== TABLE ==========")
	print("Table: ", name)
	print("State: ", get_state_name())
	print("Available seats: ", get_available_seats().size())
	
	var seat := get_available_seat()
	
	if seat:
		print("First available seat: ", seat.name)
	else:
		print("No seats available")

func get_state_name() -> String:
	match state:
		TableState.AVAILABLE:
			return "Available"

		TableState.RESERVED:
			return "Reserved"

		TableState.OCCUPIED:
			return "Occupied"

	return "Unknown"


func reserve() -> bool:
	if state != TableState.AVAILABLE:
		return false
	
	state = TableState.RESERVED
	return true


func occupy() -> bool:
	if state != TableState.RESERVED:
		return false
	
	state = TableState.OCCUPIED
	return true


func release() -> void:
	state = TableState.AVAILABLE


func get_available_seats() -> Array[Seat]:
	var available: Array[Seat] = []
	
	for seat in seats:
		if seat.is_available():
			available.append(seat)
	
	return available


func get_available_seat() -> Seat:
	for seat in seats:
		if seat.is_available():
			return seat
	
	return null
