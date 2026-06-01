extends Node

@export var wall_layer: TileMapLayer

var astar := AStarGrid2D.new()

func _ready() -> void:
	setup_grid()
	setup_solids()
	debug_draw_solids()

func setup_grid():
	var used_rect = wall_layer.get_used_rect()

	astar.region = used_rect
	astar.cell_size = wall_layer.tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

func setup_solids():
	for cell in wall_layer.get_used_cells():
		var data = wall_layer.get_cell_tile_data(cell)

		if data and data.get_custom_data("Solid"):
			astar.set_point_solid(cell, true)

func set_obstacle(world_pos: Vector2, solid: bool):
	var cell = world_to_cell(world_pos)
	
	if astar.is_in_boundsv(cell):
		astar.set_point_solid(cell, solid)

func set_obstacle_rect(world_rect: Rect2, solid: bool):
	var top_left = world_to_cell(world_rect.position)
	var bottom_right = world_to_cell(world_rect.end)
	
	for x in range(top_left.x, bottom_right.x + 1):
		for y in range(top_left.y, bottom_right.y + 1):
			var cell = Vector2i(x, y)
			
			if astar.is_in_boundsv(cell):
				astar.set_point_solid(cell, solid)

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return wall_layer.local_to_map(wall_layer.to_local(world_pos))
	
func cell_to_world(cell: Vector2i) -> Vector2:
	return wall_layer.to_global(wall_layer.map_to_local(cell))
	
func get_astar_path(start_world: Vector2, end_world: Vector2):
	var start_cell = world_to_cell(start_world)
	var end_cell = world_to_cell(end_world)
	var cell_path = astar.get_id_path(start_cell, end_cell)
	var world_path = []

	for cell in cell_path:
		world_path.append(cell_to_world(cell))

	return world_path

func debug_draw_solids():
	for x in range(astar.region.position.x, astar.region.end.x):
		for y in range(astar.region.position.y, astar.region.end.y):
			var cell = Vector2i(x, y)
			if astar.is_point_solid(cell):
				var world_pos = cell_to_world(cell)
				print("Sólido en celda: ", cell, " → mundo: ", world_pos)
