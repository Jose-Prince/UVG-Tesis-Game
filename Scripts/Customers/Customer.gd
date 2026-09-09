class_name Customer
extends CharacterBody2D


enum State {
	ENTERING,
	LOOKING_FOR_TABLE,
	WALKING_TO_SEAT,
	SITTING,
	LEAVING
}


var state: State = State.ENTERING

var target_table: Table = null
var target_seat: Seat = null


@export var speed: float = 80.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	change_state(State.LOOKING_FOR_TABLE)


func _physics_process(_delta: float) -> void:
	match state:
		State.LOOKING_FOR_TABLE:
			find_table()

		State.WALKING_TO_SEAT:
			move_to_seat()

		State.SITTING:
			velocity = Vector2.ZERO

		State.LEAVING:
			pass


func change_state(new_state: State) -> void:
	state = new_state
	
	print("Customer state: ", State.keys()[state])

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
