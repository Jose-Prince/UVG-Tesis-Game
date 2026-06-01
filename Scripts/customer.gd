extends CharacterBody2D

var movement_speed: float = 100.0
var movement_target_position: Vector2 = Vector2.ZERO
var leaving_target_position: Vector2 = Vector2.ZERO

var path: Array = []
var path_index := 0

enum States { Navigate, Sit, Wait, Order, Eat, Leave }
var currentState: States = States.Navigate

var isEating: bool = false
var leave_started: bool = false

var food: Array[String] = ["coffee", "coffee"]
var foodWanted: String = food.pick_random()

var waitingTime: int = 5

@onready var waiting_timer: Timer = $WaitingTimer
@onready var grid_manager: Node = $"../GridManager"

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame  # ← dos frames
	print("Customer calculando path...")
	set_target(Vector2(272, 160))

	waiting_timer.wait_time = waitingTime
	waiting_timer.one_shot = true
	
func _physics_process(delta: float) -> void:
	if currentState == States.Wait:
		velocity = Vector2.ZERO
		return

	#var current_agent_position: Vector2 = global_position
	#var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	#velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	follow_path()
	move_and_slide()


func _process(delta: float) -> void:
	pass
	#if currentState == States.Navigate:
		#movement_speed = 100.0
#
		##if navigation_agent.is_target_reached():
			##currentState = States.Sit
#
#
	#elif currentState == States.Sit:
		#currentState = States.Order
#
#
	#elif currentState == States.Order:
		#currentState = States.Wait
#
#
	#elif currentState == States.Wait:
		##navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		#movement_speed = 0.0
#
	#elif currentState == States.Eat:
		##navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		#movement_speed = 0.0
#
	#elif currentState == States.Leave:
		##navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
		#movement_speed = 100.0
#
		#if !leave_started:
			##navigation_agent.target_position = leaving_target_position
			#leave_started = true
			#print("Cliente saliendo")

func follow_path():
	if path.is_empty() or path_index >= path.size():
		velocity = Vector2.ZERO
		return
	
	var target = path[path_index]
	var distance = global_position.distance_to(target)
	
	if distance < 4.0:
		path_index += 1
		return
	
	velocity = global_position.direction_to(target) * movement_speed

func set_target(target_world: Vector2):
	path = grid_manager.get_astar_path(
		global_position,
		target_world
	)

	path_index = 0

func _on_customer_timer_timeout() -> void:
	isEating = false
	leave_started = false
	currentState = States.Leave
