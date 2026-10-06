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

# NEW: one SpriteFrames (.tres) per customer look
@export var customer_variants: Array[SpriteFrames] = []


@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var patience_timer: Timer = $PatienceTimer
@onready var eating_timer: Timer = $EatingTimer
@onready var patience_bar: ProgressBar = $PatienceBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D # NEW


var target_position: Vector2
var target_table: Table = null

var state: CustomerState = CustomerState.ENTERING

var order: CustomerOrder = null
var exit_position: Vector2
var leaving_initialized: bool = false

var facing_direction := Vector2.DOWN # NEW


var available_orders: Array[String] = [
	"Coffee",
	"Latte",
	"Cappuccino",
	"Cake"
]


func _ready() -> void:
	add_to_group("customer")

	# NEW: pick a random look for this customer
	if not customer_variants.is_empty():
		animated_sprite.sprite_frames = customer_variants.pick_random()
	else:
		print("ERROR: Customer has no sprite variants assigned.")

	target_position = global_position

	patience_bar.visible = false

	var exit_marker := get_tree().get_first_node_in_group("customer_exit")

	if exit_marker != null:
		exit_position = exit_marker.global_position
		print("Customer exit found at: ", exit_position)
	else:
		print("ERROR: CustomerExit was not found.")


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

	update_animation() # NEW


# -----------------------------------------
# NEW: Animation
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

	var animation_name := anim_state + "_" + direction_name

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)


func handle_entering() -> void:
	velocity = Vector2.ZERO


func handle_going_to_table() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		# NEW: look at the table while waiting
		if target_table != null:
			facing_direction = global_position.direction_to(
				target_table.global_position
			)

		change_state(CustomerState.WAITING_FOR_ORDER)

		print("Customer reached table.")

		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	velocity = direction * speed
	move_and_slide()


func handle_waiting_for_order() -> void:
	velocity = Vector2.ZERO

	if order == null:
		create_order()
		return

	if order.state == CustomerOrder.OrderState.SERVED:
		change_state(CustomerState.EATING)


func handle_eating() -> void:
	velocity = Vector2.ZERO


func handle_leaving() -> void:
	if not leaving_initialized:
		velocity = Vector2.ZERO
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		if target_table != null:
			target_table.clear_customer()

		change_state(CustomerState.EXITED)

		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	velocity = direction * speed
	move_and_slide()


func handle_exited() -> void:
	velocity = Vector2.ZERO

	print("Customer ", name, " left the café.")

	queue_free()


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

		# Stop the patience timer when the customer leaves.
		stop_patience_timer()

		start_leaving()


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

	print("Customer ", name, " finished eating.")

	if target_table != null:
		target_table.remove_food_visual()

	change_state(CustomerState.LEAVING)


func start_leaving() -> void:
	if exit_position == Vector2.ZERO:
		print("ERROR: Customer exit position was not found.")
		return

	navigation_agent.target_position = exit_position

	await get_tree().physics_frame

	leaving_initialized = true

	print("Customer leaving toward: ", exit_position)


func move_to(position: Vector2) -> void:
	target_position = position

	await get_tree().physics_frame

	navigation_agent.target_position = position


func go_to_table(table: Table) -> void:
	target_table = table

	change_state(CustomerState.GOING_TO_TABLE)

	move_to(table.get_customer_spot())


func create_order() -> void:
	var selected_item = available_orders.pick_random()

	order = CustomerOrder.new(selected_item)

	# Start the patience countdown.
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


func update_patience_bar() -> void:
	if patience_timer.is_stopped():
		return

	patience_bar.value = patience_timer.time_left


func stop_patience_timer() -> void:
	if patience_timer.is_stopped():
		return

	patience_timer.stop()
	patience_bar.visible = false

	print("Customer ", name, " patience timer stopped.")


func _on_patience_timer_timeout() -> void:
	if order == null:
		return

	# The order was already successfully served.
	if order.state == CustomerOrder.OrderState.SERVED:
		return

	# Only allow patience to expire while the customer
	# is waiting at the table.
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
