class_name CafeDayManager
extends Node


enum CafeState {
	CLOSED,
	OPEN,
	ENDING_DAY
}


@export var opening_hour: int = 9
@export var closing_hour: int = 17
@export var day_length_seconds: float = 120.0


var current_hour: float = 9.0
var current_day: int = 1

var state: CafeState = CafeState.CLOSED


func _ready() -> void:
	add_to_group("cafe_day_manager")

	current_hour = opening_hour

	print(
		"Day ",
		current_day,
		" started."
	)

	open_cafe()


func _process(delta: float) -> void:
	if state != CafeState.OPEN:
		return

	update_time(delta)


func update_time(delta: float) -> void:
	var hours_per_second := float(
		closing_hour - opening_hour
	) / day_length_seconds

	current_hour += hours_per_second * delta

	if current_hour >= closing_hour:
		current_hour = closing_hour
		close_cafe()


func open_cafe() -> void:
	if state == CafeState.OPEN:
		return

	state = CafeState.OPEN

	print(
		"Café is now OPEN at ",
		get_time_string()
	)


func close_cafe() -> void:
	if state != CafeState.OPEN:
		return

	state = CafeState.ENDING_DAY

	print(
		"Café is now CLOSED at ",
		get_time_string()
	)

	wait_for_customers()


func wait_for_customers() -> void:
	print("Waiting for all customers to leave...")

	while get_customer_count() > 0:
		print(
			"Customers remaining: ",
			get_customer_count()
		)

		await get_tree().create_timer(1.0).timeout

	start_next_day()


func get_customer_count() -> int:
	return get_tree().get_nodes_in_group("customer").size()


func start_next_day() -> void:
	current_day += 1

	current_hour = opening_hour

	print(
		"Starting Day ",
		current_day,
		"..."
	)

	open_cafe()


func is_open() -> bool:
	return state == CafeState.OPEN


func get_time_string() -> String:
	var hour := int(current_hour)
	var minute := int((current_hour - hour) * 60.0)

	return "%02d:%02d" % [hour, minute]


func get_current_hour() -> float:
	return current_hour


func get_current_day() -> int:
	return current_day
