class_name FurnitureManager
extends Node2D

@export var grid_size: int = 16

var edit_mode := false
var selected_furniture: Node2D = null
var is_dragging := false
var drag_offset := Vector2.ZERO
var player_camera: Camera2D

@onready var furniture_camera_2d: Camera2D = $FurnitureCamera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not edit_mode:
		return

	if Input.is_action_just_pressed("mouse_action"):
		print("mouse_action PRESSED")

		var furniture := get_furniture_under_mouse()

		if furniture:
			print("Furniture found: ", furniture.name)

			if furniture.has_method("can_be_moved"):
				if not furniture.can_be_moved():
					print("Furniture can't be moved")
					return

			select_furniture(furniture)
			start_drag(furniture)
		else:
			print("No furniture found")

	if is_dragging and selected_furniture:
		if Input.is_action_pressed("mouse_action"):
			var mouse_position := get_global_mouse_position()
			var new_position := mouse_position + drag_offset

			selected_furniture.global_position = snap_position(new_position)
		else:
			stop_drag()

func enter_edit_mode() -> void:
	GameData.furniture_edit_mode = true
	GameData.process_time = false
	edit_mode = true
	
	if player_camera:
		player_camera.enabled = false
	
	furniture_camera_2d.enabled = true
	
	print("Furniture edit mode: ON")

func exit_edit_mode() -> void:
	GameData.furniture_edit_mode = false
	GameData.process_time = true
	edit_mode = false
	
	is_dragging = false
	deselect_furniture()
	
	furniture_camera_2d.enabled = false
	
	if player_camera:
		player_camera.enabled = true
	print("Furniture edit mode: OFF")

func toggle_edit_mode() -> void:
	if edit_mode:
		exit_edit_mode()
	else:
		enter_edit_mode()

func get_furniture_under_mouse() -> Node2D:
	var mouse_position := get_global_mouse_position()
	var space_state := get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()

	query.position = mouse_position

	# Check every physics layer.
	query.collision_mask = 0xFFFFFFFF

	query.collide_with_bodies = true
	query.collide_with_areas = true

	var results := space_state.intersect_point(query)

	print("Physics objects under mouse: ", results.size())

	for result in results:
		var collider := result.get("collider") as Node

		if not collider:
			continue

		print(
			"Collider: ",
			collider.name,
			" | groups: ",
			collider.get_groups()
		)

		if collider.is_in_group("furniture"):
			return collider as Node2D

	return null

func select_furniture(furniture: Node2D) -> void:
	deselect_furniture()
	
	selected_furniture = furniture
	
	if selected_furniture.has_method("set_furniture_selected"):
		selected_furniture.set_furniture_selected(true)
		print("Selected: ", furniture.name)

func deselect_furniture() -> void:
	if selected_furniture:
		if selected_furniture.has_method("set_furniture_selected"):
			selected_furniture.set_furniture_selected(false)
	
	selected_furniture = null

func start_drag(furniture: Node2D) -> void:
	if not edit_mode:
		return
	
	selected_furniture = furniture
	is_dragging = true
	
	var mouse_position := get_global_mouse_position()
	drag_offset	= furniture.global_position - mouse_position
	
	print("DRAG STARTED: ", furniture.name)

func stop_drag() -> void:
	is_dragging = false

func snap_position(position: Vector2) -> Vector2:
	return Vector2(
		round(position.x / grid_size) * grid_size,
		round(position.y / grid_size) * grid_size
	)

func setup_camera(camera: Camera2D) -> void:
	player_camera = camera
