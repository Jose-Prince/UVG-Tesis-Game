extends Node2D

const CUSTOMER_SCENE = preload("res://Prefabs/customer.tscn")

var tables: Array[Node]
@onready var customer_timer: Timer = $Timer
@onready var spawn_point: Marker2D = $CustomerSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tables = get_tree().get_nodes_in_group("table")
	customer_timer.wait_time = 5.0

func _on_timer_timeout() -> void:
	call_deferred("customer_spawn")

func customer_spawn():
	var new_customer: CharacterBody2D = CUSTOMER_SCENE.instantiate()
	
	new_customer.global_position = spawn_point.global_position
	new_customer.leaving_target_position = spawn_point.global_position

	for table in tables:
		if table.isAvailable:
			var chair = table.get_free_chair()
			
			if chair:
				new_customer.movement_target_position = chair.global_position
				
				chair.isFree = false
				table.update_availability()
				
				print("Customer assigned to table")
				get_tree().current_scene.add_child(new_customer)
				customer_timer.start()
				return
				
		print("No hay sillas disponibles. Agente esperando...")
