extends StaticBody2D

signal order_completed

var chairs: Array[Node2D]
var customers: Array[Node2D]
var order: Array[String]
var isAvailable: bool = true
var check: int = 0

func get_free_chair():
	for chair in chairs:
		if chair.isFree:
			return chair
	return null

func update_availability():
	isAvailable = get_free_chair() != null
	
func interact(player):
	print(order)
	for child in player.get_children():
		var item = child.name.to_lower()
		
		if order.has(child.name.to_lower()):
			print("Served order")
			order.erase(item)
			check += child.get_price()
			child.queue_free()
			

			if order.is_empty():
				send_customers_home()
				order_completed.emit(check)
				check = 0
				
			break

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
