extends TileMapLayer

@export var interact_distance := 48.0

var player: Node2D
var occupied_tiles := {}

@onready var order_object: Node2D = $"../OrderObject"

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_world = get_global_mouse_position()
			var cell = local_to_map(to_local(mouse_world))
			
			var data = get_cell_tile_data(cell)
			
			if data == null:
				return
			
			if !data.get_custom_data("Clickable"):
				return
			
			if is_tile_occupied(cell):
				return
			
			var tile_world = to_global(map_to_local(cell))
			
			if player == null:
				return
				
			var distance = player.global_position.distance_to(tile_world)
			if distance > interact_distance:
				return
				
			if order_object.get_child_count() == 0:
				return

			var obj = order_object.get_child(0)

			if obj.has_method("drop"):
				obj.drop()
			
			obj.reparent(self)

			obj.global_position = tile_world

			print(
				"Objeto colocado en:",
				cell
			)

func set_tile_occupied(world_pos: Vector2, occupied: bool):
	var cell = local_to_map(to_local(world_pos))
	
	if occupied:
		occupied_tiles[cell] = true
	else:
		occupied_tiles.erase(cell)

func is_tile_occupied(cell: Vector2i) -> bool:
	return occupied_tiles.has(cell)
