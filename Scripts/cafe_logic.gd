extends Node2D

const CUSTOMER_SCENE = preload("res://Prefabs/customer.tscn")

const loop: AudioStream = preload("res://Music/Dream_Cafe.ogg")

# Probando - Eliminar luego
const intro_test: AudioStream = preload("res://Music/CafeSwing_Intro.ogg")
const loop_test: AudioStream = preload("res://Music/CafeSwing.ogg")
const test_a: Array = [[null, loop], [intro_test, loop_test]]

var restaurant_menu: Array[ArticleData]

var tables: Array[Node]
var coffee_name := ""

var time_gui: Control
var time_system: TimeSystem

var is_open := false

@onready var customer_timer: Timer = $Timer
@onready var spawn_point: Marker2D = $CustomerSpawn
@onready var scene_transition: CanvasLayer = $SceneTransition


func _ready() -> void:
	for id in GameData.menu_ids:
		restaurant_menu.append(
			ArticleDatabase.articles[int(id)]
		)
	
	GameData.menu = restaurant_menu
	
	# Probando - Eliminar luego
	var music_to_test: Array = test_a.pick_random()
	MusicManager.play_song(music_to_test[0], music_to_test[1])
	
	await scene_transition.pixelate_out(0.6).finished
	
	time_gui = find_child("TimeGui", true, false)
	time_system = find_child("TimeSystem", true, false)
	tables = get_tree().get_nodes_in_group("table")
	
	if time_gui:
		time_gui.shop_opened.connect(_on_shop_opened)
		time_gui.shop_closed.connect(_on_shop_closed)
		
	for table in tables:
		table.order_completed.connect(time_gui.add_point)

func _process(delta: float) -> void:
	find_scaled_nodes(self)

func find_scaled_nodes(node: Node):
	for child in node.get_children():
		if child is Node2D:
			if child.scale == Vector2(0.5, 0.5):
				print("Encontrado: ", child.get_path())

		find_scaled_nodes(child)

func _on_timer_timeout() -> void:
	if not is_open:
		return
	
	call_deferred("customer_spawn")

func customer_spawn() -> void:
	if not is_open:
		return
	
	update_customer_rate()
	customer_timer.start()
	
	var available_tables := []
	
	for table in tables:
		var free_chairs = table.get_free_chairs()
		
		if (
			table.actual_state == table.States.AVAILABLE
			and free_chairs != null
			and free_chairs.size() > 0
		):
			available_tables.append(table)
		
	if available_tables.is_empty():
		print("No hay mesas disponibles")
		return
	
	var selected_table = available_tables.pick_random()
	var chairs: Array = selected_table.get_free_chairs()
	
	var max_customers_possible = min(2, chairs.size())
	var amount_to_spawn = randi_range(1, max_customers_possible)
	
	var customers_to_spawn: Array[Customer] = []
	
	for i in amount_to_spawn:
		var new_customer: Customer = CUSTOMER_SCENE.instantiate() as Customer
		
		new_customer.foodWanted = GameData.menu.pick_random()
		
		customers_to_spawn.append(new_customer)
		
	for i in customers_to_spawn.size():
		var customer = customers_to_spawn[i]
		var chair = chairs[i]
		
		selected_table.assign_customer(customer)
		
		customer.global_position = spawn_point.global_position
		customer.leaving_target_position = spawn_point.global_position
		
		customer.assign_chair(chair)
		chair.isFree = false
		
		selected_table.set_state(
			selected_table.States.UNAVAILABLE
		)
		
		get_tree().current_scene.add_child(customer)
		
		customer.set_target(
			chair.go_to_pos.global_position
		)
	
	await get_tree().physics_frame
	
	selected_table.set_state(
		selected_table.States.UNAVAILABLE
	)
	
	SfxManager.play_bell()


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


func get_popularity_ratio() -> float:
	return clamp(
		GameData.popularity / 1000.0,
		0.0,
		1.0
	)


func get_time_factor() -> float:
	return lerp(
		2.5,
		1.0,
		get_popularity_ratio()
	)


func update_customer_rate() -> void:
	var popularity_ratio = get_popularity_ratio()
	var popularity_factor = sqrt(popularity_ratio)
	
	var base_spawn_time = lerp(
		50.0,
		8.0,
		popularity_factor
	)

	customer_timer.wait_time = (
		base_spawn_time
		/ get_hour_factor()
		/ time_system.time_factor
	)


func _on_shop_opened() -> void:
	is_open = true
	print(get_time_factor())
	time_system.set_time_factor(
		get_time_factor()
	)
	
	update_customer_rate()
	customer_timer.start()


func _on_shop_closed() -> void:
	is_open = false
	
	time_system.set_time_factor(1.0)
	
	customer_timer.stop()


func _on_leaving_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("customer"):
		if body.currentState == body.States.Leave:
			body.queue_free()
