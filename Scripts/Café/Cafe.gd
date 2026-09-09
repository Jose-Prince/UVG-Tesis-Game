extends Node2D


const CUSTOMER_SCENE = preload("res://Scenes/Customers/Customer.tscn")

@onready var customer_spawn: Marker2D = $CustomerSpawn


func _ready() -> void:
	spawn_customer()


func spawn_customer() -> void:
	var customer := CUSTOMER_SCENE.instantiate()
	
	add_child(customer)
	
	customer.global_position = customer_spawn.global_position
