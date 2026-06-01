extends CharacterBody2D

var movement_speed: float = 100.0
var leaving_target_position: Vector2 = Vector2.ZERO

var path: Array = []
var path_index := 0

enum States { Navigate, Sit, Wait, Order, Eat, Leave }
var currentState: States = States.Navigate

var leave_started := false
var chair_reached := false

var food: Array[String] = ["coffee", "coffee"]
var foodWanted: String = food.pick_random()

var waitingTime: int = 5

@onready var waiting_timer: Timer = $WaitingTimer
@onready var grid_manager: Node = $"../GridManager"

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame 

	waiting_timer.wait_time = waitingTime
	waiting_timer.one_shot = true
	
func _physics_process(delta: float) -> void:
	match currentState:
		States.Navigate:
			follow_path()
			
			if path_finished() && !chair_reached:
				chair_reached = true
				currentState = States.Sit
				
		States.Sit:
			velocity = Vector2.ZERO
			currentState = States.Wait
			
		States.Wait:
			velocity = Vector2.ZERO
			
		States.Eat:
			velocity = Vector2.ZERO
			
		States.Leave:
			if !leave_started:
				set_target(leaving_target_position)
				leave_started = true
				print("leaving")
			
			follow_path()
			
	move_and_slide()

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
	path = grid_manager.get_astar_path(global_position, target_world)
	path_index = 0

func path_finished() -> bool:
	return path_index >= path.size()

func _on_customer_timer_timeout() -> void:
	leave_started = false
	currentState = States.Leave
