class_name Player
extends CharacterBody2D


@export var speed: float = 200.0
@export var interaction_distance: float = 70.0
@export var food_visual_scene: PackedScene


@onready var interaction_prompt: Label = $InteractionPrompt
@onready var carry_position: Marker2D = $CarryPosition
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var facing_direction := Vector2.DOWN
var current_interactable: Interactable = null

var carrying_order: CustomerOrder = null
var carrying_food_visual: FoodVisual = null


func _ready() -> void:
	add_to_group("player")
	if SceneTransition.spawn_point_name.is_empty():
		return

	var spawn_point := get_tree().current_scene.get_node_or_null(
		SceneTransition.spawn_point_name
	)

	if spawn_point:
		global_position = spawn_point.global_position

	SceneTransition.spawn_point_name = ""


func _physics_process(_delta: float) -> void:
	handle_movement()
	update_animation()
	update_carry_position()
	update_interaction()
	handle_interaction()


func update_carry_position() -> void:
	if carry_position == null:
		return

	var distance := 24.0

	carry_position.position = facing_direction * distance

	if carrying_food_visual != null:
		carrying_food_visual.position = carry_position.position

func handle_movement() -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if direction.length() > 1.0:
		direction = direction.normalized()

	if direction != Vector2.ZERO:
		facing_direction = direction

	velocity = direction * speed

	move_and_slide()

func update_animation() -> void:
	var state := "walk" if velocity != Vector2.ZERO else "idle"
	var direction_name: String

	if abs(facing_direction.x) > abs(facing_direction.y):
		direction_name = "side"
		animated_sprite.flip_h = facing_direction.x < 0
	elif facing_direction.y < 0:
		direction_name = "up"
		animated_sprite.flip_h = false
	else:
		direction_name = "down"
		animated_sprite.flip_h = false

	var animation_name := state + "_" + direction_name

	# Use carry version if it exists (e.g. "walk_down_carry")
	if carrying_order != null:
		var carry_name := animation_name + "_carry"
		if animated_sprite.sprite_frames.has_animation(carry_name):
			animation_name = carry_name

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func update_interaction() -> void:
	current_interactable = null

	var closest_distance := INF

	for node in get_tree().get_nodes_in_group("interactable"):
		if not is_instance_valid(node):
			continue

		if not node is Interactable:
			continue

		var interaction_position = node.get_interaction_position()

		var distance := global_position.distance_to(
			interaction_position
		)

		var max_distance = (
			interaction_distance
			+ node.interaction_radius
		)

		if distance <= max_distance and distance < closest_distance:
			closest_distance = distance
			current_interactable = node

	interaction_prompt.visible = current_interactable != null


func handle_interaction() -> void:
	if not Input.is_action_just_pressed("interact"):
		return

	if current_interactable == null:
		return


	# --------------------------------------------------
	# TABLE INTERACTION
	# --------------------------------------------------

	if current_interactable is Table:
		var table := current_interactable as Table

		if carrying_order != null:
			var delivered := table.deliver_order(
				carrying_order
			)

			if delivered:
				carrying_order = null

			return


	# --------------------------------------------------
	# NORMAL INTERACTION
	# --------------------------------------------------

	current_interactable.interact()


func pick_up_order(order: CustomerOrder) -> void:
	if carrying_order != null:
		print(
			"Player is already carrying: ",
			carrying_order.item_name
		)
		return

	if order == null:
		return

	if order.state != CustomerOrder.OrderState.READY:
		return

	carrying_order = order

	create_carried_food_visual(order)

	print(
		"Player picked up: ",
		order.item_name
	)


func create_carried_food_visual(
	order: CustomerOrder
) -> void:

	if food_visual_scene == null:
		print(
			"ERROR: FoodVisual scene is not assigned to Player."
		)
		return

	if carry_position == null:
		print(
			"ERROR: CarryPosition was not found."
		)
		return

	if carrying_food_visual != null:
		return

	carrying_food_visual = (
		food_visual_scene.instantiate()
		as FoodVisual
	)

	if carrying_food_visual == null:
		print(
			"ERROR: Could not create carried FoodVisual."
		)
		return

	add_child(carrying_food_visual)

	carrying_food_visual.position = (
		carry_position.position
	)

	carrying_food_visual.setup(order)

	print(
		"Carried food visual created: ",
		order.item_name
	)


func remove_carried_food_visual() -> void:
	if carrying_food_visual == null:
		return

	carrying_food_visual.queue_free()

	carrying_food_visual = null

	print(
		"Carried food visual removed."
	)

func is_carrying_order() -> bool:
	return carrying_order != null

func clear_carried_order() -> void:
	remove_carried_food_visual()
	carrying_order = null

	print("[PLAYER] Carried order cleared")
