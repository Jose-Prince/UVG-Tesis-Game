extends CharacterBody2D

@export var speed: float = 200.0
@export var interaction_distance: float = 70.0

@onready var interaction_prompt: Label = $InteractionPrompt

var current_interactable: Interactable = null


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
	if Input.is_action_just_pressed("interact"):
		if current_interactable != null:
			current_interactable.interact()
