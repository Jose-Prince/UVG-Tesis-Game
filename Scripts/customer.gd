extends CharacterBody2D

class_name Customer	

var target_chair = null
var movement_speed: float = 100.0
var leaving_target_position: Vector2 = Vector2.ZERO

var path: Array = []
var path_index := 0

enum States { Navigate, Sit, Wait, Order, Eat, Leave }
var currentState: States = States.Navigate

var leave_started := false
var chair_reached := false

var food: Array[String] = ["coffee", "water"]
var foodWanted: String = food.pick_random()

var waitingTime: int = 5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var waiting_timer: Timer = $WaitingTimer
@onready var grid_manager: Node = $"../GridManager"
@onready var label: Label = $Label

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
			label.text = foodWanted
			
		States.Eat:
			velocity = Vector2.ZERO
			label.text = ""
			
		States.Leave:
			if !leave_started:
				set_target(leaving_target_position)
				leave_started = true
				print("leaving")
			
			follow_path()
			
	update_animation()
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

func update_animation():
	# Idle
	if velocity == Vector2.ZERO:
		if animated_sprite.animation == "walk_up":
			animated_sprite.play("idle_up")
		elif animated_sprite.animation == "walk_right":
			animated_sprite.play("idle_right")
		else:
			animated_sprite.play("idle")
		return

	# Walking
	if abs(velocity.x) > abs(velocity.y):
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = velocity.x < 0
	else:
		if velocity.y < 0:
			animated_sprite.play("walk_up")
		else:
			animated_sprite.play("walk_down")

		animated_sprite.flip_h = false

func set_target(target_world: Vector2):
	path = grid_manager.get_astar_path(global_position, target_world)
	path_index = 0

func path_finished() -> bool:
	return path_index >= path.size()

func _on_sitting_timer_timeout() -> void:
	print("Agente se va")
	
	if target_chair:
		target_chair.isFree = true
	
func _on_customer_timer_timeout() -> void:
	leave_started = false
	currentState = States.Leave
	
func assign_chair(chair):
	target_chair = chair
	target_chair.isFree = false
	
	#movement_target_position = target_chair.go_to_pos.global_position
