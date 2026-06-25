extends StaticBody2D

signal order_completed

var chairs: Array[Node2D]
var customers: Array[Node2D]
var orders := []
var isAvailable: bool = true
var check: float = 0
var placed_food: Array[Node2D]
var table_popularity := 0

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var grid_manager: Node = $"../GridManager"
@onready var food_place_1: Marker2D = $FoodPlace1
@onready var food_place_2: Marker2D = $FoodPlace2
@onready var order_object: Node2D = $"../OrderObject"
@onready var waiting_timer: Timer = $WaitingTimer
@onready var circular_bar: TextureProgressBar = $CircularBar

func _ready():
	await get_tree().physics_frame

	progress_bar.max_value = timer.wait_time
	
	circular_bar.max_value = waiting_timer.wait_time
	circular_bar.value = 0
	
	var shape = $collider.shape
	var rect = Rect2(global_position - shape.size/2, shape.size)
	grid_manager.set_obstacle_rect(rect, true)
	
func _process(delta: float) -> void:
	z_index = int(global_position.y)
	if timer.time_left > 0:
		progress_bar.value = timer.wait_time - timer.time_left
	
	if waiting_timer.time_left > 0:
		circular_bar.value = waiting_timer.wait_time - waiting_timer.time_left

func get_free_chairs():
	var free_chairs := []

	for chair in chairs:
		if chair.isFree:
			free_chairs.append(chair)

	if free_chairs.is_empty():
		return null

	return free_chairs

func update_availability():
	isAvailable = get_free_chairs() != null
	
func interact(player):
	print(customers)
	print("POPULARITY: " + str(table_popularity))
	var delivered := false
	
	for child in order_object.get_children():
		var item_id = child.article_data.id

		for order_data in orders:
			if order_data.food.id == item_id:
				check += child.get_price()
				
				for order in orders:
					print(
						"ORDER CUSTOMER: ",
						order.customer,
						" VALID: ",
						is_instance_valid(order.customer)
					)
				
				place_food(child, order_data.customer)
				
				if is_instance_valid(order_data.customer):
					order_data.customer.speech_bubble.hide_order()
				
				orders.erase(order_data)
				delivered = true

				if orders.is_empty():
					start_eating()
					check += calculate_tip()
					table_popularity += calculate_popularity_bonus()
					progress_bar.visible = true
					progress_bar.value = 0
					timer.start()
					order_completed.emit(check)
					check = 0

				return

		if !delivered:
			for customer in customers:
				if is_instance_valid(customer):
					table_popularity -= 1

	if !delivered:
		for order_data in orders:
			if is_instance_valid(order_data.customer):
				order_data.customer.speech_bubble.show_order([order_data.food])

func place_food(food, customer):
	var markers = [food_place_1, food_place_2]
	var free_markers := []
	
	for marker in markers:
		var occupied := false
		
		for placed in placed_food:
			if is_instance_valid(placed) && placed.global_position == marker.global_position:
				occupied = true
				break
		
		if !occupied:
			free_markers.append(marker)
	if free_markers.is_empty():
		return
	
	var closest_marker = free_markers[0]
	var closest_distance = customer.global_position.distance_to(
		closest_marker.global_position
	)
	
	for marker in free_markers:
		var dist = customer.global_position.distance_to(
			marker.global_position
		)
		
		if dist < closest_distance:
			closest_distance = dist
			closest_marker = marker
		
	if food.has_method("drop"):
		food.drop()
	
	food.reparent(self)
	food.global_position = closest_marker.global_position
	
	if food.has_method("place"):
		food.place()
	
	placed_food.append(food)

func clear_food():
	for food in placed_food:
		if is_instance_valid(food):
			food.queue_free()
			
	placed_food.clear()

func start_eating():
	circular_bar.visible = false
	
	for customer in customers:
		if is_instance_valid(customer):
			customer.currentState = customer.States.Eat

func send_customers_home():
	orders.clear()
	
	waiting_timer.stop()
	waiting_timer.wait_time = 0
	
	circular_bar.visible = false
	
	for customer in customers:
		if is_instance_valid(customer):
			customer.currentState = customer.States.Leave
			
	isAvailable = true
	
	for chair in chairs:
		chair.isFree = true
		
	customers.clear()
	
	GameData.popularity += table_popularity
	if GameData.popularity < 0:
		GameData.popularity = 0
	table_popularity = 0
	
	print("ACTUAL POPULARITY: " + str(GameData.popularity))

func assign_customer(customer):
	if customer not in customers:
		customers.append(customer)
		table_popularity += 1
		orders.append({
			"customer": customer,
			"food": customer.foodWanted
		})
		
		waiting_timer.wait_time += customer.foodWanted.prep_time
		circular_bar.max_value = waiting_timer.wait_time

func check_all_customers_seated():
	if customers.is_empty():
		return

	for customer in customers:
		if !is_instance_valid(customer):
			return

		if !customer.chair_reached:
			return

	if waiting_timer.is_stopped():
		circular_bar.visible = true
		waiting_timer.start()

func calculate_tip() -> float:
	if waiting_timer.wait_time <= 0:
		return 0.0

	var time_ratio := waiting_timer.time_left / waiting_timer.wait_time
	time_ratio = clamp(time_ratio, 0.0, 1.0)

	return check * (time_ratio * 0.20)

func calculate_popularity_bonus() -> int:
	if waiting_timer.wait_time <= 0:
		return 0

	var time_ratio := waiting_timer.time_left / waiting_timer.wait_time
	time_ratio = clamp(time_ratio, 0.0, 1.0)

	return round(time_ratio * customers.size())

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("chair"):
		chairs.append(body)
		body.assign_table(self)

func _on_timer_timeout() -> void:
	progress_bar.visible = false
	clear_food()
	send_customers_home()
	
func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_waiting_timer_timeout() -> void:
	table_popularity += customers.size() * -3
	send_customers_home()
