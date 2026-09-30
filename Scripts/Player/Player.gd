class_name Player
extends CharacterBody2D

@export var speed: float = 200.0
@export var interaction_distance: float = 70.0

@onready var interaction_prompt: Label = $InteractionPrompt
@onready var order_ui: CanvasLayer = get_tree().get_first_node_in_group("order_ui")

var current_interactable: Interactable = null
var carrying_order: CustomerOrder = null

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	handle_movement()
	update_interaction()
	handle_interaction()


func handle_movement() -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()


func update_interaction() -> void:
	current_interactable = null

	var closest_distance := INF

	for node in get_tree().get_nodes_in_group("interactable"):
		if not is_instance_valid(node):
			continue

		if not node is Interactable:
			continue

		var interaction_position = node.get_interaction_position()
		var distance := global_position.distance_to(interaction_position)

		var max_distance = interaction_distance + node.interaction_radius

		if distance <= max_distance and distance < closest_distance:
			closest_distance = distance
			current_interactable = node

	interaction_prompt.visible = current_interactable != null

func handle_interaction() -> void:
	if not Input.is_action_just_pressed("interact"):
		return

	if current_interactable == null:
		return

	if current_interactable is Table:
		var table := current_interactable as Table

		if carrying_order != null:
			var delivered := table.deliver_order(carrying_order)

			if delivered:
				carrying_order = null

			return

	current_interactable.interact()

func pick_up_order(order: CustomerOrder) -> void:
	if carrying_order != null:
		print("Player is already carrying: ", carrying_order.item_name)
		return

	if order == null:
		return

	if order.state != CustomerOrder.OrderState.READY:
		return

	carrying_order = order

	print("Player picked up: ", order.item_name)


func is_carrying_order() -> bool:
	return carrying_order != null
