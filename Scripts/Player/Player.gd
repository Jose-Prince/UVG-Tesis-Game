class_name Player
extends CharacterBody2D


@export var speed: float = 150.0
@export var interaction_distance: float = 48.0

var nearby_interactable: Interactable


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_interact()


func try_interact() -> void:
	var interactables := get_tree().get_nodes_in_group("interactable")

	var closest: Interactable = null
	var closest_distance := interaction_distance

	for object in interactables:
		if not object is Interactable:
			continue

		var distance := global_position.distance_to(object.global_position)

		if distance <= closest_distance:
			closest = object
			closest_distance = distance

	if closest:
		closest.interact(self)
