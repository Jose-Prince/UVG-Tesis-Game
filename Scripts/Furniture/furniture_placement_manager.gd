extends Node

@export var wooden_table_scene: PackedScene
@export var wooden_chair_scene: PackedScene

var placement_mode: bool = false
var selected_item_id: String = ""
var preview: Node2D = null

func _process(_delta: float) -> void:
	if not placement_mode:
		return

	var mouse_position = get_tree().current_scene.get_global_mouse_position()

	if Input.is_action_just_pressed("click"):
		confirm_placement(mouse_position)

	if Input.is_action_just_pressed("ui_cancel"):
		cancel_placement()

func start_placement(item_id: String) -> void:
	if not FurnitureInventory.has_item(item_id):
		print("[PLACEMENT] No item available: ", item_id)
		return

	selected_item_id = item_id
	placement_mode = true

	print("[PLACEMENT] Started: ", item_id)


func cancel_placement() -> void:
	placement_mode = false
	selected_item_id = ""

	if preview:
		preview.queue_free()
		preview = null

	print("[PLACEMENT] Cancelled")


func confirm_placement(position: Vector2) -> void:
	if not placement_mode:
		return

	if selected_item_id.is_empty():
		return

	if not FurnitureInventory.has_item(selected_item_id):
		cancel_placement()
		return

	var furniture := create_furniture(selected_item_id)

	if furniture == null:
		print("[PLACEMENT] Failed to create furniture: ", selected_item_id)
		return

	get_tree().current_scene.add_child(furniture)

	furniture.global_position = snap_to_grid(position)

	FurnitureInventory.remove_item(selected_item_id)

	print(
		"[PLACEMENT] Placed: ",
		selected_item_id,
		" at ",
		furniture.global_position
	)

	cancel_placement()


func create_furniture(item_id: String) -> Node2D:
	match item_id:
		"wooden_table":
			if wooden_table_scene:
				return wooden_table_scene.instantiate() as Node2D

		"wooden_chair":
			if wooden_chair_scene:
				return wooden_chair_scene.instantiate() as Node2D

	return null

func create_wooden_table() -> Node2D:
	var table := Node2D.new()

	var visual := ColorRect.new()
	visual.color = Color("#8B5E3C")
	visual.position = Vector2(-32, -32)
	visual.size = Vector2(64, 64)

	table.add_child(visual)

	return table


func create_wooden_chair() -> Node2D:
	var chair := Node2D.new()

	var visual := ColorRect.new()
	visual.color = Color("#A8754D")
	visual.position = Vector2(-16, -16)
	visual.size = Vector2(32, 32)

	chair.add_child(visual)

	return chair


func snap_to_grid(position: Vector2) -> Vector2:
	var tile_size := 32.0

	return Vector2(
		round(position.x / tile_size) * tile_size,
		round(position.y / tile_size) * tile_size
	)
