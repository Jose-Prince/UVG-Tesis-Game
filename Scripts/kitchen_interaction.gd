extends TileMapLayer

@export var interact_distance := 48.0

var player: Node2D
var interaction_point: Marker2D
var occupied_tiles := {}

@onready var order_object: Node2D = $"../OrderObject"

func _input(event: InputEvent) -> void:
	player = get_tree().get_first_node_in_group("player")
	if !_is_interaction_event(event):
		return
	
	if _is_interaction_event(event) == event.is_action_pressed("key_action"):
		_interact_at_point_position()
	
	if _is_interaction_event(event) == event.is_action_pressed("mouse_action"):
		_interact_at_mouse_position()


func _is_interaction_event(event: InputEvent) -> bool:
	match GameData.interaction_mode:
		GameData.InteractionMode.KEYBOARD:
			return event.is_action_pressed("key_action")

		GameData.InteractionMode.MOUSE:
			return event.is_action_pressed("mouse_action")

	return false


func _interact_at_mouse_position() -> void:
	if player == null:
		return

	var mouse_world := get_global_mouse_position()
	var cell := local_to_map(to_local(mouse_world))

	var data := get_cell_tile_data(cell)

	if data == null:
		return

	if !data.get_custom_data("Clickable"):
		return

	var tile_world := to_global(map_to_local(cell))

	if player.global_position.distance_to(tile_world) > interact_distance:
		return

	if is_tile_occupied(cell):
		_pickup_object(cell)
	else:
		_place_object(cell, tile_world)

func _interact_at_point_position() -> void:
	interaction_point = player.find_child("InteractionPoint")
	
	var point_world = interaction_point.global_position
	
	var cell := local_to_map(to_local(point_world))
	
	var data := get_cell_tile_data(cell)

	if data == null:
		return

	if !data.get_custom_data("Clickable"):
		return

	var tile_world := to_global(map_to_local(cell))

	if player.global_position.distance_to(tile_world) > interact_distance:
		return
	
	if is_tile_occupied(cell):
		_pickup_object(cell)
	else:
		_place_object(cell, tile_world)

func set_tile_occupied(world_pos: Vector2, occupied: bool, object: Node2D) -> void:
	var cell := local_to_map(to_local(world_pos))

	if occupied:
		occupied_tiles[cell] = object
	else:
		occupied_tiles.erase(cell)


func is_tile_occupied(cell: Vector2i) -> bool:
	return occupied_tiles.has(cell)

func _place_object(cell: Vector2i, tile_world: Vector2) -> void:
	if order_object.get_child_count() == 0:
		return

	var obj := order_object.get_child(0)

	if obj.has_method("drop"):
		obj.drop()

	obj.reparent(self)
	obj.global_position = tile_world

	set_tile_occupied(
		tile_world,
		true,
		obj
	)
	
func _pickup_object(cell: Vector2i) -> void:
	if order_object.get_child_count() > 0:
		return

	var obj = occupied_tiles.get(cell)

	if obj == null:
		return

	occupied_tiles.erase(cell)
	obj.reparent(order_object)
	obj.pickup(player)
