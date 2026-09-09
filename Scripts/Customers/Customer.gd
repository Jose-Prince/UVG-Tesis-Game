class_name Customer
extends CharacterBody2D


enum State {
	ENTERING,
	LOOKING_FOR_TABLE,
	WALKING_TO_SEAT,
	SITTING,
	WAITING_TO_ORDER,
	ORDERING,
	WAITING_FOR_FOOD,
	EATING,
	PAYING,
	LEAVING
}

var order: CustomerOrder = null
var order_wait_time: float = 0.0

var state: State = State.ENTERING

var target_table: Table = null
var target_seat: Seat = null

@export var order_wait_duration: float = 2.0
@export var speed: float = 80.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	change_state(State.LOOKING_FOR_TABLE)


func _physics_process(delta: float) -> void:
	match state:
		State.LOOKING_FOR_TABLE:
			find_table()

		State.WALKING_TO_SEAT:
			move_to_seat()

		State.SITTING:
			velocity = Vector2.ZERO

		State.WAITING_TO_ORDER:
			wait_for_order(delta)

		State.ORDERING:
			velocity = Vector2.ZERO

		State.WAITING_FOR_FOOD:
			velocity = Vector2.ZERO

		State.LEAVING:
			pass

func change_state(new_state: State) -> void:
	state = new_state
	
	print("Customer state: ", State.keys()[state])
	
	match state:
		State.SITTING:
			start_waiting_for_order()
		
		State.ORDERING:
			create_order()

func find_table() -> void:
	var tables := get_tree().get_nodes_in_group("tables")
	
	for object in tables:
		if object is Table:
			var table: Table = object
			
			if table.state != Table.TableState.AVAILABLE:
				continue
			
			var seat := table.get_available_seat()
			
			if seat == null:
				continue
			
			if table.reserve():
				target_table = table
				target_seat = seat
				
				print("Customer reserved table: ", table.name)
				
				target_seat.occupy(self)
				
				navigation_agent.target_position = target_seat.global_position
				
				change_state(State.WALKING_TO_SEAT)
				
				return
	
	print("No available table")

func move_to_seat() -> void:
	if target_seat == null:
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		global_position = target_seat.global_position
		
		change_state(State.SITTING)
		
		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	velocity = direction * speed

	move_and_slide()

func start_waiting_for_order() -> void:
	order_wait_time = 0.0

func wait_for_order(delta: float) -> void:
	order_wait_time += delta
	
	if order_wait_time >= order_wait_duration:
		change_state(State.ORDERING)

func create_order() -> void:
	order = CustomerOrder.new()
	
	var menu_items: Array[MenuItem] = get_available_menu_items()
	
	if menu_items.is_empty():
		print("No menu items available")
		return
	
	var item: MenuItem = menu_items.pick_random()
	
	order.add_item(item)
	
	print("========== CUSTOMER ORDER ==========")
	print("Customer: ", name)
	print("Item: ", item.item_name)
	print("Price: $", item.price)
	print("Total: $", order.total)
	
	OrderManager.add_order(order)
	
	change_state(State.WAITING_FOR_FOOD)

func get_available_menu_items() -> Array[MenuItem]:
	var menu: Array[MenuItem] = []
	
	var coffee := MenuItem.new()
	coffee.id = "coffee"
	coffee.item_name = "Coffee"
	coffee.price = 3.0
	
	var latte := MenuItem.new()
	latte.id = "latte"
	latte.item_name = "Latte"
	latte.price = 4.5
	
	var cake := MenuItem.new()
	cake.id = "cake"
	cake.item_name = "Cake"
	cake.price = 5.0
	
	menu.append(coffee)
	menu.append(latte)
	menu.append(cake)
	
	return menu
