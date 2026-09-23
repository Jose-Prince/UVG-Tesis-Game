extends CharacterBody2D

@export var speed: float = 200.0
@export var interaction_distance: float = 64.0

@onready var interaction_point: Marker2D = $InteractionPoint
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

	var closest_distance := interaction_distance

	for node in get_tree().get_nodes_in_group("interactable"):
		if not is_instance_valid(node):
			continue

		var distance := interaction_point.global_position.distance_to(
			node.global_position
		)

		if distance <= closest_distance:
			closest_distance = distance
			current_interactable = node

	interaction_prompt.visible = current_interactable != null


func handle_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		if current_interactable != null:
			current_interactable.interact()
