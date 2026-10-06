extends Node

@export var wooden_table_scene: PackedScene
@export var wooden_chair_scene: PackedScene

var placement_mode: bool = false
var removal_mode: bool = false

var selected_item_id: String = ""
var preview: Node2D = null

var placed_furniture: Array[Node2D] = []

func _process(_delta: float) -> void:
	if placement_mode:
		var mouse_position = get_tree().current_scene.get_global_mouse_position()

		if Input.is_action_just_pressed("click"):
			confirm_placement(mouse_position)

		if Input.is_action_just_pressed("ui_cancel"):
			cancel_mode()

	elif removal_mode:
		if Input.is_action_just_pressed("click"):
			print("[REMOVAL] Click detected")

			var furniture := get_furniture_at_mouse()

			if furniture:
				print("[REMOVAL] Found furniture: ", furniture.name)
				remove_furniture(furniture)
			else:
				print("[REMOVAL] No furniture found")

		if Input.is_action_just_pressed("ui_cancel"):
			cancel_mode()

func start_placement(item_id: String) -> void:
	if not FurnitureInventory.has_item(item_id):
		print("[PLACEMENT] No item available: ", item_id)
		return

	removal_mode = false
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
		cancel_mode()
		return

	var furniture := create_furniture(selected_item_id)

	if furniture == null:
		print("[PLACEMENT] Failed to create furniture: ", selected_item_id)
		return

	get_tree().current_scene.add_child(furniture)

	furniture.add_to_group("placed_furniture")
	furniture.set_meta("furniture_id", selected_item_id)

	placed_furniture.append(furniture)

	furniture.global_position = snap_to_grid(position)

	FurnitureInventory.remove_item(selected_item_id)

	print(
		"[PLACEMENT] Placed: ",
		selected_item_id,
		" at ",
		furniture.global_position
	)

	cancel_mode()

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

func start_removal() -> void:
	placement_mode = false
	removal_mode = true
	selected_item_id = ""

	print("[REMOVAL] Started")


func cancel_mode() -> void:
	placement_mode = false
	removal_mode = false
	selected_item_id = ""

	if preview:
		preview.queue_free()
		preview = null

	print("[FURNITURE] Mode cancelled")

func get_furniture_at_mouse() -> Node2D:
	var mouse_position = get_tree().current_scene.get_global_mouse_position()

	# First check furniture placed through the furniture editor.
	for furniture in placed_furniture:
		if not is_instance_valid(furniture):
			continue

		if is_mouse_over_furniture(furniture, mouse_position):
			return furniture

	# Also check furniture that was already part of the scene.
	var furniture_nodes := get_tree().get_nodes_in_group("furniture")

	for node in furniture_nodes:
		if not is_instance_valid(node):
			continue

		var furniture := node as Node2D

		if furniture == null:
			continue

		if is_mouse_over_furniture(furniture, mouse_position):
			return furniture

	return null

func find_furniture_parent(node: Node) -> Node2D:
	var current := node

	while current:
		if current.is_in_group("placed_furniture"):
			return current as Node2D

		current = current.get_parent()

	return null

func remove_furniture(furniture: Node2D) -> void:
	if furniture == null:
		return

	var item_id: String = ""

	# Furniture placed through the editor already has an ID.
	if furniture.has_meta("furniture_id"):
		item_id = furniture.get_meta("furniture_id")

	# If it was originally in the scene, determine its ID
	# from its type.
	elif furniture is Table:
		item_id = "wooden_table"

	else:
		print("[REMOVAL] Unknown furniture type: ", furniture.name)
		return

	# Return the furniture to the inventory.
	FurnitureInventory.add_item(item_id)

	# Remove it from our runtime list if it is there.
	placed_furniture.erase(furniture)

	print(
		"[REMOVAL] Removed: ",
		furniture.name,
		" | ID: ",
		item_id,
		" | Returned to inventory"
	)

	furniture.queue_free()

	cancel_mode()

func is_mouse_over_furniture(
	furniture: Node2D,
	mouse_position: Vector2
) -> bool:
	var local_position := furniture.to_local(mouse_position)

	var rect := Rect2(
		Vector2(-32, -32),
		Vector2(64, 64)
	)

	return rect.has_point(local_position)
