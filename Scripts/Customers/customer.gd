class_name Customer
extends CharacterBody2D


enum CustomerState {
	ENTERING,
	GOING_TO_TABLE,
	WAITING_FOR_ORDER,
	EATING,
	LEAVING,
	EXITED
}


@export var speed: float = 100.0
@export var eating_time: float = 5.0
@export var patience_time: float = 20.0

# One SpriteFrames (.tres) per customer look
@export var customer_variants: Array[SpriteFrames] = []


@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var patience_timer: Timer = $PatienceTimer
@onready var eating_timer: Timer = $EatingTimer
@onready var patience_bar: ProgressBar = $PatienceBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var assigned_table: Table = null
var assigned_seat: TableSeat = null

var target_position: Vector2
var target_table: Table = null

var state: CustomerState = CustomerState.ENTERING

var order: CustomerOrder = null
var exit_position: Vector2
var leaving_initialized: bool = false

var facing_direction := Vector2.DOWN


var available_orders: Array[String] = [
	"Coffee",
	"Latte",
	"Cappuccino",
	"Cake"
]


func _ready() -> void:
	add_to_group("customer")

	# -----------------------------------------
	# Customer appearance
	# -----------------------------------------

	if not customer_variants.is_empty():
		animated_sprite.sprite_frames = customer_variants.pick_random()
	else:
		print(
			"ERROR: Customer has no sprite variants assigned."
		)

	# -----------------------------------------
	# Initial position
	# -----------------------------------------

	target_position = global_position

	patience_bar.visible = false

	# -----------------------------------------
	# Find exit
	# -----------------------------------------

	var exit_marker := get_tree().get_first_node_in_group(
		"customer_exit"
	)

	if exit_marker != null:
		exit_position = exit_marker.global_position

		print(
			"Customer exit found at: ",
			exit_position
		)
	else:
		print(
			"ERROR: CustomerExit was not found."
		)


func _physics_process(_delta: float) -> void:
	update_patience_bar()

	match state:
		CustomerState.ENTERING:
			handle_entering()

		CustomerState.GOING_TO_TABLE:
			handle_going_to_table()

		CustomerState.WAITING_FOR_ORDER:
			handle_waiting_for_order()

		CustomerState.EATING:
			handle_eating()

		CustomerState.LEAVING:
			handle_leaving()

		CustomerState.EXITED:
			handle_exited()

	update_animation()


# -----------------------------------------
# Animation
# -----------------------------------------

func update_animation() -> void:
	if animated_sprite.sprite_frames == null:
		return

	var is_moving := velocity.length() > 1.0

	if is_moving:
		facing_direction = velocity

	var anim_state := "walk" if is_moving else "idle"

	var direction_name: String

	if abs(facing_direction.x) > abs(facing_direction.y):
		direction_name = "side"
		animated_sprite.flip_h = facing_direction.x < 0

	elif facing_direction.y < 0:
		direction_name = "up"
		animated_sprite.flip_h = false

	else:
		direction_name = "down"
		animated_sprite.flip_h = false

	var animation_name := (
		anim_state + "_" + direction_name
	)

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)


# -----------------------------------------
# Entering
# -----------------------------------------

func handle_entering() -> void:
	velocity = Vector2.ZERO


# -----------------------------------------
# Going to table
# -----------------------------------------

func handle_going_to_table() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		# Face the table from the seat.
		if assigned_table != null:
			facing_direction = global_position.direction_to(
				assigned_table.global_position
			)

		change_state(
			CustomerState.WAITING_FOR_ORDER
		)

		print(
			"Customer ",
			name,
			" reached seat."
		)

		return

	var next_position := (
		navigation_agent.get_next_path_position()
	)

	var direction := global_position.direction_to(
		next_position
	)

	velocity = direction * speed

	move_and_slide()


# -----------------------------------------
# Waiting for order
# -----------------------------------------

func handle_waiting_for_order() -> void:
	velocity = Vector2.ZERO

	if order == null:
		create_order()
		return

	if order.state == CustomerOrder.OrderState.SERVED:
		change_state(CustomerState.EATING)


# -----------------------------------------
# Eating
# -----------------------------------------

func handle_eating() -> void:
	velocity = Vector2.ZERO


# -----------------------------------------
# Leaving
# -----------------------------------------

func handle_leaving() -> void:
	if not leaving_initialized:
		velocity = Vector2.ZERO
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		release_seat()

		change_state(CustomerState.EXITED)

		return

	var next_position := (
		navigation_agent.get_next_path_position()
	)

	var direction := global_position.direction_to(
		next_position
	)

	velocity = direction * speed

	move_and_slide()


# -----------------------------------------
# Exited
# -----------------------------------------

func handle_exited() -> void:
	velocity = Vector2.ZERO

	print(
		"Customer ",
		name,
		" left the café."
	)

	queue_free()


# -----------------------------------------
# State changes
# -----------------------------------------

func change_state(new_state: CustomerState) -> void:
	if state == new_state:
		return

	print(
		"Customer ",
		name,
		": ",
		CustomerState.keys()[state],
		" -> ",
		CustomerState.keys()[new_state]
	)

	state = new_state

	if state == CustomerState.EATING:
		start_eating()

	if state == CustomerState.LEAVING:
		leaving_initialized = false

		# Stop the patience timer.
		stop_patience_timer()

		start_leaving()


# -----------------------------------------
# Eating timer
# -----------------------------------------

func start_eating() -> void:
	eating_timer.wait_time = eating_time
	eating_timer.start()

	print(
		"Customer ",
		name,
		" is eating for ",
		eating_time,
		" seconds."
	)


func _on_eating_timer_timeout() -> void:
	if state != CustomerState.EATING:
		return

	print(
		"Customer ",
		name,
		" finished eating."
	)

	if target_table != null:
		target_table.remove_food_visual()

	change_state(CustomerState.LEAVING)


# -----------------------------------------
# Leaving
# -----------------------------------------

func start_leaving() -> void:
	if exit_position == Vector2.ZERO:
		print(
			"ERROR: Customer exit position was not found."
		)

		return

	navigation_agent.target_position = exit_position

	await get_tree().physics_frame

	leaving_initialized = true

	print(
		"Customer leaving toward: ",
		exit_position
	)


# -----------------------------------------
# Navigation
# -----------------------------------------

func move_to(position: Vector2) -> void:
	target_position = position

	await get_tree().physics_frame

	navigation_agent.target_position = position


func go_to_table(table: Table) -> void:
	if table == null:
		print("ERROR: Cannot go to null table.")
		return

	var seat := table.assign_customer(self)

	if seat == null:
		print(
			"Customer ",
			name,
			" could not find an available seat."
		)

		return

	target_table = table
	assigned_table = table
	assigned_seat = seat

	change_state(CustomerState.GOING_TO_TABLE)

	move_to(seat.global_position)

	print(
		"Customer ",
		name,
		" going to ",
		table.name,
		" / ",
		seat.name,
		" at ",
		seat.global_position
	)


# -----------------------------------------
# Seat management
# -----------------------------------------

func release_seat() -> void:
	if assigned_seat != null:
		assigned_seat.clear_customer()

		print(
			"Customer ",
			name,
			" released seat ",
			assigned_seat.name
		)

	assigned_seat = null
	assigned_table = null
	target_table = null


# -----------------------------------------
# Orders
# -----------------------------------------

func create_order() -> void:
	var selected_item = available_orders.pick_random()

	order = CustomerOrder.new(selected_item)

	patience_timer.wait_time = patience_time
	patience_timer.start()

	patience_bar.max_value = patience_time
	patience_bar.value = patience_time
	patience_bar.visible = true

	print(
		"Customer ",
		name,
		" ordered: ",
		order.item_name,
		" | Patience: ",
		patience_time,
		" seconds"
	)


# -----------------------------------------
# Patience
# -----------------------------------------

func update_patience_bar() -> void:
	if patience_timer.is_stopped():
		return

	patience_bar.value = patience_timer.time_left


func stop_patience_timer() -> void:
	if patience_timer.is_stopped():
		return

	patience_timer.stop()

	patience_bar.visible = false

	print(
		"Customer ",
		name,
		" patience timer stopped."
	)


func _on_patience_timer_timeout() -> void:
	if order == null:
		return

	# The order was already served.
	if order.state == CustomerOrder.OrderState.SERVED:
		return

	# Only allow patience to expire while waiting.
	if state != CustomerState.WAITING_FOR_ORDER:
		return

	order.state = CustomerOrder.OrderState.EXPIRED

	patience_bar.visible = false

	print(
		"Customer ",
		name,
		" became impatient and is leaving."
	)

	change_state(CustomerState.LEAVING)
