extends Node2D

const CUSTOMER_SCENE = preload("res://Prefabs/customer.tscn")

var tables: Array[Node]
var coffee_name := ""

var time_gui : Control

@onready var customer_timer: Timer = $Timer
@onready var spawn_point: Marker2D = $CustomerSpawn
@onready var scene_transition: CanvasLayer = $SceneTransition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await scene_transition.pixelate_out(0.6).finished
	
	var time_gui = find_child("TimeGui", true, false)
	tables = get_tree().get_nodes_in_group("table")
	
	for table in tables:
		table.order_completed.connect(time_gui.add_point)
		
	customer_timer.wait_time = 5.0
	customer_timer.start()

func _on_timer_timeout() -> void:
	call_deferred("customer_spawn")

func customer_spawn():
	customer_timer.start()
	
	var available_tables := []
	
	for table in tables:
		if table.isAvailable and table.get_free_chair():
			available_tables.append(table)
	
	if available_tables.is_empty():
		print("No hay mesas disponibles")
		return
	
	var selected_table = available_tables.pick_random()
	var chair = selected_table.get_free_chair()
	
	if chair == null:
		return
	
	var new_customer: CharacterBody2D = CUSTOMER_SCENE.instantiate()
	
	selected_table.assign_customer(new_customer)
	
	new_customer.global_position = spawn_point.global_position
	new_customer.leaving_target_position = spawn_point.global_position
	
	new_customer.assign_chair(chair)
	
	chair.isFree = false
	selected_table.update_availability()
	
	get_tree().current_scene.add_child(new_customer)
	
	await get_tree().physics_frame
	
	new_customer.set_target(chair.go_to_pos.global_position)

func _on_leaving_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("customer"):
		if body.currentState == body.States.Leave:
			print("Customer despawned")
			body.queue_free()
