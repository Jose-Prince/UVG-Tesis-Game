extends Node2D

const CUSTOMER_SCENE = preload("res://Prefabs/Customer.tscn")

@onready var chairs: Array = [$Chair, $Chair2, $Chair3, $Chair4]
@onready var customer_timer: Timer = $Timer
@onready var spawn_point: Marker2D = $CustomerSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	customer_timer.wait_time = 5.0

func _on_timer_timeout() -> void:
	call_deferred("customer_spawn")

func customer_spawn():
	var new_customer: CharacterBody2D = CUSTOMER_SCENE.instantiate()
	
	new_customer.global_position = spawn_point.global_position
	
	for chair in chairs:
		if chair.isFree:
			new_customer.movement_target_position = chair.global_position
			new_customer.leaving_target_position = spawn_point.global_position
			print("Customer to ", chair.global_position)
			chair.isFree = false
			break
			
		print("No hay sillas disponibles. Agente esperando...")
			
	get_tree().current_scene.add_child(new_customer)
	customer_timer.wait_time = 3.0
	customer_timer.start()
