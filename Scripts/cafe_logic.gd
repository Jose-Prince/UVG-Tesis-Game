extends Node2D
const CUSTOMER_SCENE = preload("res://Prefabs/customer.tscn")

var restaurant_menu: Array[ArticleData]

var tables: Array[Node]
var coffee_name := ""
var time_gui: Control

@onready var customer_timer: Timer = $Timer
@onready var spawn_point: Marker2D = $CustomerSpawn
@onready var scene_transition: CanvasLayer = $SceneTransition

func _ready() -> void:
	for id in GameData.menu_ids:
		restaurant_menu.append(ArticleDatabase.articles[int(id)])
	GameData.menu = restaurant_menu
	print(GameData.menu_ids)
	print(restaurant_menu)
	await scene_transition.pixelate_out(0.6).finished
	
	time_gui = find_child("TimeGui", true, false)
	tables = get_tree().get_nodes_in_group("table")
	
	for table in tables:
		table.order_completed.connect(time_gui.add_point)
	
	var popularity_ratio = GameData.popularity / 1000.0
	var popularity_factor = sqrt(popularity_ratio)
	var base_spawn_time = lerp(50.0, 8.0, popularity_factor)
	var final_spawn_time = base_spawn_time / get_hour_factor()
	
	customer_timer.wait_time = final_spawn_time
	customer_timer.start()

func _on_timer_timeout() -> void:
	call_deferred("customer_spawn")

func customer_spawn():
	update_customer_rate()
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

func get_hour_factor() -> float:
	var hour = time_gui.actual_hour
	
	if hour < 8:
		return 0.5
	
	if hour < 10:
		return 1.0
	
	if hour < 12:
		return 1.3
	
	if hour < 14:
		return 1.8
	
	if hour < 16:
		return 1.2
	
	return 0.7

func update_customer_rate():
	var popularity_ratio = GameData.popularity / 1000.0
	var popularity_factor = sqrt(popularity_ratio)
	
	var base_spawn_time = lerp(
		50.0,
		8.0,
		popularity_factor
	)
	
	customer_timer.wait_time = (
		base_spawn_time /
		get_hour_factor()
	)

func _on_leaving_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("customer"):
		if body.currentState == body.States.Leave:
			print("Customer despawned")
			body.queue_free()
