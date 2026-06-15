extends StaticBody2D

signal order_completed

var chairs: Array[Node2D]
var customers: Array[Node2D]
var orders := []
var isAvailable: bool = true
var check: int = 0
var placed_food: Array[Node2D]

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var grid_manager: Node = $"../GridManager"
@onready var food_place_1: Marker2D = $FoodPlace1
@onready var food_place_2: Marker2D = $FoodPlace2
@onready var order_object: Node2D = $"../OrderObject"

func _ready():
	await get_tree().physics_frame

	progress_bar.max_value = timer.wait_time
	
	var shape = $collider.shape
	var rect = Rect2(global_position - shape.size/2, shape.size)
	grid_manager.set_obstacle_rect(rect, true)
	
func _process(delta: float) -> void:
	z_index = int(global_position.y)
	if timer.time_left > 0:
		progress_bar.value = timer.wait_time - timer.time_left

func get_free_chair():
	var free_chairs := []

	for chair in chairs:
		if chair.isFree:
			free_chairs.append(chair)

	if free_chairs.is_empty():
		return null

	return free_chairs.pick_random()

func update_availability():
	isAvailable = get_free_chair() != null
	
func interact(player):
	print(orders)
	for child in order_object.get_children():
		var item = child.name.to_lower()
		
		for order_data in orders:
			if order_data.food == item:
				check += child.get_price()
				
				place_food(child, order_data.customer)
				
				orders.erase(order_data)
				
				if orders.is_empty():
					start_eating()
					
					progress_bar.visible = true
					progress_bar.value = 0
					
					timer.start()
					
					order_completed.emit(check)
					check = 0
					
				return

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
	for customer in customers:
		if is_instance_valid(customer):
			customer.currentState = customer.States.Eat

func send_customers_home():
	for customer in customers:
		if is_instance_valid(customer):
			customer.currentState = customer.States.Leave
			
	isAvailable = true
	
	for chair in chairs:
		chair.isFree = true
		
	customers.clear()

func assign_customer(customer):
	if customer not in customers:
		customers.append(customer)
		orders.append({
			"customer": customer,
			"food": customer.foodWanted
		})

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("chair"):
		print("Silla asignada")
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
