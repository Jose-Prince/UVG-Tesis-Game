extends CharacterBody2D

@export var speed: float = 200.0
@export var interaction_distance: float = 70.0

@onready var interaction_prompt: Label = $InteractionPrompt
@onready var skin: AnimatedSprite2D = $Skin
@onready var hair: AnimatedSprite2D = $Hair
@onready var top_cloth: AnimatedSprite2D = $TopCloth
@onready var bottom_cloth: AnimatedSprite2D = $BottomCloth

var current_interactable: Interactable = null

var last_direction := Vector2.DOWN
var is_running := false
var is_holding := false

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

	if direction != Vector2.ZERO:
		last_direction = direction
		update_animation(direction)
	else:
		update_idle_animation()


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

func update_animation(direction: Vector2) -> void:
	var animation_name := ""

	# Determine whether we are running
	is_running = Input.is_action_pressed("run")

	# Determine direction
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animation_name = "right"
		else:
			animation_name = "right"

			# Flip the sprite layers instead of needing a left animation
			set_sprite_flip(true)

	else:
		if direction.y > 0:
			animation_name = "down"
		else:
			animation_name = "up"

		set_sprite_flip(false)

	# Determine walk/run
	var movement_type := "run" if is_running else "walk"

	# Determine whether holding an object
	var prefix := "hold_" if is_holding else ""

	var final_animation := prefix + movement_type + "_" + animation_name

	play_all_layers(final_animation)
	
func update_idle_animation() -> void:
	var animation_name := ""

	if abs(last_direction.x) > abs(last_direction.y):
		animation_name = "right"

		if last_direction.x < 0:
			set_sprite_flip(true)
		else:
			set_sprite_flip(false)

	else:
		if last_direction.y > 0:
			animation_name = "down"
		else:
			animation_name = "up"

		set_sprite_flip(false)

	var prefix := "hold_" if is_holding else ""
	var final_animation := prefix + "idle" + ("_" + animation_name if animation_name != "down" else "")

	play_all_layers(final_animation)

func play_all_layers(animation_name: String) -> void:
	skin.play(animation_name)
	hair.play(animation_name)
	top_cloth.play(animation_name)
	bottom_cloth.play(animation_name)

func set_sprite_flip(flipped: bool) -> void:
	skin.flip_h = flipped
	hair.flip_h = flipped
	top_cloth.flip_h = flipped
	bottom_cloth.flip_h = flipped
