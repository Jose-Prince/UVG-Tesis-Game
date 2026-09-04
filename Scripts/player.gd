class_name Player
extends CharacterBody2D

const TILE_SIZE := 32
const INTERACTION_RADIUS := 18.0

const SKIN_FRAMES: SpriteFrames = preload(
	"res://Assets/Sprites/character/player_skin.tres"
)

const HAIR_FRAMES: Array = [
	preload("res://Assets/Sprites/character/hair_1.tres"),
	preload("res://Assets/Sprites/character/hair_2.tres"),
	preload("res://Assets/Sprites/character/hair_3.tres"),
]

const SHIRT_FRAMES: Array = [
	preload("res://Assets/Sprites/character/shirt_1.tres"),
	preload("res://Assets/Sprites/character/shirt_2.tres"),
]

const PANTS_FRAMES: Array = [
	preload("res://Assets/Sprites/character/pants_1.tres"),
	preload("res://Assets/Sprites/character/pants_2.tres"),
]

@export var speed := 400.0
@export var run_speed := 650.0

var player_name := ""

var current_object = null
var current_npc: NPC = null
var held_item = null

var facing := Vector2.DOWN

var current_tile := Vector2i.ZERO
var last_facing := Vector2.ZERO

@onready var skin: AnimatedSprite2D = $skin
@onready var clothes_bottom: AnimatedSprite2D = $clothes_bottom
@onready var clothes_top: AnimatedSprite2D = $clothes_top
@onready var hair: AnimatedSprite2D = $hair

@onready var interaction_point: Marker2D = $InteractionPoint
@onready var pointer_sprite: AnimatedSprite2D = $InteractionPoint/PointerSprite

func _ready() -> void:
	await get_tree().process_frame

	apply_appearance()
	update_interaction_visibility()
	update_interaction_point()


func _process(_delta: float) -> void:
	queue_redraw()
	z_index = int(global_position.y)


func _physics_process(_delta: float) -> void:
	_process_movement_input()
	_process_interaction_input()

	update_animation()

	if held_item:
		held_item.update_bob(skin.animation, skin.frame)

	move_and_slide()


# ============================================================
# MOVEMENT
# ============================================================

func _process_movement_input() -> void:
	var input_direction := Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)

	var current_speed := _get_current_speed()

	velocity = input_direction * current_speed


func _get_current_speed() -> float:
	var running := Input.is_action_pressed("run")

	if GameData.auto_run:
		return speed if running else run_speed

	return run_speed if running else speed


# ============================================================
# INTERACTION
# ============================================================

func _process_interaction_input() -> void:
	match GameData.interaction_mode:
		GameData.InteractionMode.KEYBOARD:
			_process_keyboard_interaction()

		GameData.InteractionMode.MOUSE:
			_process_mouse_interaction()


# ============================================================
# KEYBOARD INTERACTION
# ============================================================

func _process_keyboard_interaction() -> void:
	var interaction_direction := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	if interaction_direction != Vector2.ZERO:
		facing = _get_8_direction(interaction_direction)
	elif velocity != Vector2.ZERO:
		facing = _get_8_direction(velocity)

	update_interaction_visibility()
	update_interaction_point()

	if Input.is_action_just_pressed("key_action"):
		_interact()


# ============================================================
# MOUSE INTERACTION
# ============================================================

func _process_mouse_interaction() -> void:
	update_interaction_visibility()
	update_mouse_interaction_point()

	if Input.is_action_just_pressed("mouse_action"):
		_interact()


func _interact() -> void:
	if current_object:
		current_object.interact(self)

	if current_npc:
		current_npc.talk()


# ============================================================
# 8 DIRECTIONS
# ============================================================

func _get_8_direction(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return facing

	var angle := direction.angle()

	var octant = round(angle / (PI / 4.0))
	var direction_index := int(octant) % 8

	if direction_index < 0:
		direction_index += 8

	match direction_index:
		0:
			return Vector2.RIGHT

		1:
			return Vector2(1, 1).normalized()

		2:
			return Vector2.DOWN

		3:
			return Vector2(-1, 1).normalized()

		4:
			return Vector2.LEFT

		5:
			return Vector2(-1, -1).normalized()

		6:
			return Vector2.UP

		7:
			return Vector2(1, -1).normalized()

	return facing


# ============================================================
# INTERACTION VISIBILITY
# ============================================================

func update_interaction_visibility() -> void:
	if !GameData.show_interaction:
		interaction_point.hide()
		return

	if velocity != Vector2.ZERO and GameData.hide_interaction_moving:
		interaction_point.hide()
		return

	interaction_point.show()


# ============================================================
# INTERACTION POINT
# ============================================================

func update_interaction_point() -> void:
	var direction := _get_8_direction(facing)
	
	_set_interaction_point_position(direction)

func update_mouse_interaction_point() -> void:
	var mouse_position := get_global_mouse_position()

	# La dirección se calcula desde el centro del sprite
	# del jugador hacia el mouse.
	var direction := mouse_position - global_position

	if direction == Vector2.ZERO:
		return

	facing = _get_8_direction(direction)

	_set_interaction_point_position(facing)


func _set_interaction_point_position(direction: Vector2) -> void:
	interaction_point.global_position = (
		global_position + direction * INTERACTION_RADIUS
	)


# ============================================================
# ANIMATION
# ============================================================

func update_animation() -> void:
	pointer_sprite.play("default")

	var is_running := _is_running()
	var is_holding := held_item != null

	if velocity == Vector2.ZERO:
		_play_idle_animation(is_holding)
		return

	var prefix := _get_movement_animation_prefix(
		is_holding,
		is_running
	)

	_play_movement_animation(prefix)


func _is_running() -> bool:
	if velocity == Vector2.ZERO:
		return false

	return GameData.auto_run != Input.is_action_pressed("run")


func _get_movement_animation_prefix(
	is_holding: bool,
	is_running: bool
) -> String:

	if is_holding:
		if is_running:
			return "hold_run"

		return "hold_walk"

	if is_running:
		return "run"

	return "walk"


func _play_idle_animation(is_holding: bool) -> void:
	if is_holding:
		if skin.animation.contains("up"):
			play_layers("hold_idle_up")
		elif skin.animation.contains("right"):
			play_layers("hold_idle_right")
		else:
			play_layers("hold_idle")
	else:
		if skin.animation.contains("up"):
			play_layers("idle_up")
		elif skin.animation.contains("right"):
			play_layers("idle_right")
		else:
			play_layers("idle")


func _play_movement_animation(prefix: String) -> void:
	if abs(velocity.x) > abs(velocity.y):
		play_layers(prefix + "_right")
		flip_layers(velocity.x < 0)

		if held_item:
			held_item.set_hold_direction(
				"right",
				velocity.x < 0
			)

		return

	if velocity.y < 0:
		play_layers(prefix + "_up")
		flip_layers(false)

		if held_item:
			held_item.set_hold_direction("up", false)

		return

	play_layers(prefix + "_down")
	flip_layers(false)

	if held_item:
		held_item.set_hold_direction("down", false)


# ============================================================
# APPEARANCE
# ============================================================

func apply_appearance() -> void:
	skin.sprite_frames = SKIN_FRAMES
	skin.modulate = GameData.player_skin_color

	hair.sprite_frames = HAIR_FRAMES[GameData.player_hair_style]
	hair.modulate = GameData.player_hair_color

	clothes_top.sprite_frames = SHIRT_FRAMES[GameData.player_shirt_style]
	clothes_top.modulate = GameData.player_shirt_color

	clothes_bottom.sprite_frames = PANTS_FRAMES[GameData.player_pants_style]
	clothes_bottom.modulate = GameData.player_pants_color


func play_layers(anim_name: String) -> void:
	if skin.animation == anim_name and skin.is_playing():
		return

	skin.play(anim_name)
	clothes_bottom.play(anim_name)
	clothes_top.play(anim_name)
	hair.play(anim_name)


func flip_layers(value: bool) -> void:
	skin.flip_h = value
	clothes_bottom.flip_h = value
	clothes_top.flip_h = value
	hair.flip_h = value


# ============================================================
# HELD ITEM
# ============================================================

func set_held_item(item) -> void:
	held_item = item

	if held_item == null:
		return

	var direction := "down"

	if skin.animation.contains("up"):
		direction = "up"
	elif skin.animation.contains("right"):
		direction = "right"

	held_item.set_hold_direction(
		direction,
		skin.flip_h
	)


# ============================================================
# DETECTION
# ============================================================

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("clickable"):
		current_object = body

	if body is NPC:
		current_npc = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == current_object:
		current_object = null

	if body == current_npc:
		current_npc = null
