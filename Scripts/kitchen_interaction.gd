extends TileMapLayer

@export var interact_distance := 48.0

var player: Node2D
var occupied_tiles := {}

@onready var order_object: Node2D = $"../OrderObject"

func _input(event):
	player = get_tree().get_first_node_in_group("player")
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_world = get_global_mouse_position()
			var cell = local_to_map(to_local(mouse_world))
			
			var data = get_cell_tile_data(cell)
			
			if data == null:
				return
			print("PASO 1")
			if !data.get_custom_data("Clickable"):
				return
			print("PASO 2")
			if is_tile_occupied(cell):
				return
			print("PASO 3")
			var tile_world = to_global(map_to_local(cell))

			var distance = player.global_position.distance_to(tile_world)
			if distance > interact_distance:
				return
			print("PASO 5")
			if order_object.get_child_count() == 0:
				return
			print("PAOS 6")
			var obj = order_object.get_child(0)
	
			if obj.has_method("drop"):
				obj.drop()
			obj.reparent(self)

			obj.global_position = tile_world

func set_tile_occupied(world_pos: Vector2, occupied: bool):
	var cell = local_to_map(to_local(world_pos))
	
	if occupied:
		occupied_tiles[cell] = true
	else:
		occupied_tiles.erase(cell)

func is_tile_occupied(cell: Vector2i) -> bool:
	return occupied_tiles.has(cell)
