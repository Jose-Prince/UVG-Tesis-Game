extends CharacterBody2D
class_name Customer

var target_chair = null
var movement_speed: float = 100.0
var leaving_target_position: Vector2 = Vector2.ZERO
var path: Array = []
var path_index := 0
enum States { Navigate, Sit, Wait, Order, Eat, Leave }
var currentState: States = States.Navigate
var leave_started := false
var chair_reached := false
var foodWanted: ArticleData
var order_shown := false

# appearance
const SKIN_COLORS: Array[Color] = [
	Color(1.0, 0.90, 0.70),
	Color(0.90, 0.70, 0.50),
	Color(0.75, 0.55, 0.35),
	Color(0.55, 0.35, 0.20),
	Color(0.35, 0.22, 0.12),
]
const HAIR_COLORS: Array[Color] = [
	Color(0.15, 0.10, 0.05),
	Color(0.35, 0.20, 0.10),
	Color(0.60, 0.35, 0.15),
	Color(0.80, 0.65, 0.25),
	Color(0.80, 0.30, 0.10),
	Color(0.75, 0.75, 0.75),
	Color(0.90, 0.25, 0.25),
]
const CLOTHES_COLORS: Array[Color] = [
	Color(0.20, 0.40, 0.70),
	Color(0.70, 0.20, 0.20),
	Color(0.20, 0.60, 0.30),
	Color(0.80, 0.75, 0.20),
	Color(0.60, 0.20, 0.70),
	Color(0.85, 0.50, 0.15),
	Color(0.30, 0.30, 0.30),
	Color(0.90, 0.90, 0.90),
]
const SKIN_FRAMES: SpriteFrames = preload("res://Sprites/character/skin.tres")
const SHIRT_FRAMES: Array = [
	preload("res://Sprites/character/shirt_1.tres"),
	preload("res://Sprites/character/shirt_2.tres"),
]
const PANTS_FRAMES: Array = [
	preload("res://Sprites/character/pants_1.tres"),
	preload("res://Sprites/character/pants_2.tres"),
]
const HAIR_FRAMES: Array = [
	preload("res://Sprites/character/hair_1.tres"),
	preload("res://Sprites/character/hair_2.tres"),
	preload("res://Sprites/character/hair_3.tres"),
]

@onready var skin_layer: AnimatedSprite2D = $skin
@onready var clothes_bottom: AnimatedSprite2D = $clothes_bottom
@onready var clothes_top: AnimatedSprite2D = $clothes_top
@onready var hair_layer: AnimatedSprite2D = $hair
@onready var grid_manager: Node = $"../GridManager"
@onready var speech_bubble: Node2D = $SpeechBubble

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	randomize_appearance()

func randomize_appearance() -> void:
	skin_layer.sprite_frames = SKIN_FRAMES 
	skin_layer.modulate = SKIN_COLORS.pick_random()
	hair_layer.sprite_frames = HAIR_FRAMES.pick_random()
	hair_layer.modulate = HAIR_COLORS.pick_random()
	clothes_top.sprite_frames = SHIRT_FRAMES.pick_random()
	clothes_top.modulate = CLOTHES_COLORS.pick_random()
	clothes_bottom.sprite_frames = PANTS_FRAMES.pick_random()
	clothes_bottom.modulate = CLOTHES_COLORS.pick_random()

func play_layers(anim_name: String) -> void:
	if skin_layer.animation == anim_name:
		return
	skin_layer.play(anim_name)
	clothes_bottom.play(anim_name)
	clothes_top.play(anim_name)
	hair_layer.play(anim_name)

func flip_layers(value: bool) -> void:
	skin_layer.flip_h = value
	clothes_bottom.flip_h = value
	clothes_top.flip_h = value
	hair_layer.flip_h = value

func _physics_process(delta: float) -> void:
	if currentState == States.Sit or currentState == States.Wait or currentState == States.Eat:
		if target_chair:
			z_index = int(target_chair.global_position.y) + 1
		else:
			z_index = int(global_position.y) + 1
	else:
		z_index = int(global_position.y)

	match currentState:
		States.Navigate:
			follow_path()
			if !path.is_empty() and path_finished() and !chair_reached:
				chair_reached = true
				if target_chair and target_chair.assigned_table:
					target_chair.assigned_table.check_all_customers_seated()
				currentState = States.Sit

		States.Sit:
			if target_chair:
				global_position = target_chair.get_sit_position()
			face_table()
			velocity = Vector2.ZERO
			currentState = States.Wait

		States.Wait:
			velocity = Vector2.ZERO

		States.Eat:
			velocity = Vector2.ZERO
			speech_bubble.hide_order()

		States.Leave:
			if !leave_started:
				order_shown = false
				speech_bubble.hide_order()
				
				global_position = target_chair.go_to_pos.global_position
				
				set_target(leaving_target_position)
				leave_started = true
			follow_path()

	update_animation()
	move_and_slide()

func follow_path():
	if path.is_empty() or path_index >= path.size():
		velocity = Vector2.ZERO
		return
	var target = path[path_index]
	var distance = global_position.distance_to(target)
	if distance < 4.0:
		path_index += 1
		return
	velocity = global_position.direction_to(target) * movement_speed

func update_animation():
	if currentState == States.Wait \
	or currentState == States.Eat \
	or currentState == States.Sit:
		return

	# Idle
	if velocity == Vector2.ZERO:
		if skin_layer.animation == "walk_up":
			play_layers("idle_up")
		elif skin_layer.animation == "walk_right":
			play_layers("idle_right")
		else:
			play_layers("idle")
		return

	# Walking
	if abs(velocity.x) > abs(velocity.y):
		play_layers("walk_right")
		flip_layers(velocity.x < 0)
	else:
		if velocity.y < 0:
			play_layers("walk_up")
		else:
			play_layers("walk_down")
		flip_layers(false)

func set_target(target_world: Vector2):
	path = grid_manager.get_astar_path(global_position, target_world)
	path_index = 0

func path_finished() -> bool:
	return path_index >= path.size()

func assign_chair(chair):
	target_chair = chair
	target_chair.isFree = false

func face_table():
	if !target_chair:
		return
	play_layers("idle_right")
	flip_layers(target_chair.isRotated)
