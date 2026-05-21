extends CharacterBody2D

var movement_speed: float = 100.0
var movement_target_position: Vector2 = Vector2.ZERO
var leaving_target_position: Vector2 = Vector2.ZERO

enum States { Navigate, Sit, Wait, Order, Eat, Leave }
var currentState: States = States.Navigate

var isEating: bool = false
var leave_started: bool = false

var food: Array[String] = ["coffee", "coffee"]
var foodWanted: String = food.pick_random()

var waitingTime: int = 5

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var waiting_timer: Timer = $WaitingTimer


func _ready() -> void:
	await get_tree().physics_frame

	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	navigation_agent.target_position = movement_target_position

	waiting_timer.wait_time = waitingTime
	waiting_timer.one_shot = true

func _physics_process(delta: float) -> void:
	if currentState == States.Wait:
		velocity = Vector2.ZERO
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed

	move_and_slide()


func _process(delta: float) -> void:

	if currentState == States.Navigate:
		navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
		movement_speed = 100.0

		if navigation_agent.is_target_reached():
			currentState = States.Sit


	elif currentState == States.Sit:
		currentState = States.Order


	elif currentState == States.Order:
		currentState = States.Wait


	elif currentState == States.Wait:
		navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		movement_speed = 0.0

	elif currentState == States.Eat:
		navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		movement_speed = 0.0

	elif currentState == States.Leave:
		navigation_agent.process_mode = Node.PROCESS_MODE_ALWAYS
		movement_speed = 100.0

		if !leave_started:
			navigation_agent.target_position = leaving_target_position
			leave_started = true
			print("Cliente saliendo")

func _on_customer_timer_timeout() -> void:
	isEating = false
	leave_started = false
	currentState = States.Leave
