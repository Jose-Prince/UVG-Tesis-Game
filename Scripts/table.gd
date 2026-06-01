extends StaticBody2D

signal order_completed

var chairs: Array[Node2D]
var customers: Array[Node2D]
var order: Array[String]
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
	for chair in chairs:
		if chair.isFree:
			return chair
	return null

func update_availability():
	isAvailable = get_free_chair() != null
	
func interact(player):
	print(order)
	for child in order_object.get_children():
		var item = child.name.to_lower()
		
		if order.has(child.name.to_lower()):
			print("Served order")
			order.erase(item)
			check += child.get_price()
			place_food(child)
			
			if order.is_empty():
				start_eating()
				
				progress_bar.visible = true
				progress_bar.value = 0
				
				timer.start()
				
				order_completed.emit(check)
				check = 0
				
			break

func place_food(food):
	var marker: Marker2D = null
	
	if placed_food.size() == 0:
		marker = food_place_1
	elif placed_food.size() == 1:
		marker = food_place_2
	else:
		return
	
	if food.has_method("drop"):
		food.drop()
	
	food.reparent(self)
	food.global_position = marker.global_position
	
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

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("chair"):
		print("Silla asignada")
		chairs.append(body)
	
	if body.is_in_group("customer"):
		print("En la mesa")
		customers.append(body)
		order.append(body.foodWanted)

func _on_timer_timeout() -> void:
	progress_bar.visible = false
	clear_food()
	send_customers_home()
