extends CharacterBody2D

const TILE_SIZE := 16

@export var speed : float = 400.0
@export var run_speed : float = 650.0

var player_name := ""
var current_object = null
var held_item = null
var facing := Vector2.DOWN

var current_tile := Vector2i.ZERO
var last_facing := Vector2.ZERO


@onready var skin: AnimatedSprite2D = $skin
@onready var clothes: AnimatedSprite2D = $clothes
@onready var lineart: AnimatedSprite2D = $lineart
@onready var hair: AnimatedSprite2D = $hair
@onready var interaction_point: Marker2D = $InteractionPoint
@onready var pointer_sprite: AnimatedSprite2D = $InteractionPoint/PointerSprite

func play_layers(anim_name: String):
	skin.play(anim_name)
	clothes.play(anim_name)
	lineart.play(anim_name)
	hair.play(anim_name)

func flip_layers(value: bool):
	skin.flip_h = value
	clothes.flip_h = value
	lineart.flip_h = value
	hair.flip_h = value
	
func _process(delta: float):
	queue_redraw()
	z_index = int(global_position.y)

func _physics_process(delta: float) -> void:
	get_input()
	make_action()
	update_animation()

	if held_item:
		held_item.update_bob(skin.animation, skin.frame)

	move_and_slide()
	
func get_input():
	var current_speed = speed
	
	# Set the player speed for auto run
	if GameData.auto_run:
		current_speed = run_speed
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var interaction_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if interaction_direction != Vector2.ZERO:
		facing = interaction_direction.normalized()
	
	elif input_direction != Vector2.ZERO:
		facing = input_direction.normalized()
	
	update_interaction_point()
	
	if Input.is_action_pressed("run"):
		if GameData.auto_run:
			current_speed = speed
		else:
			current_speed = run_speed
	
	velocity = input_direction * current_speed

func update_interaction_point():
	var dir := Vector2(sign(facing.x), sign(facing.y))
	var player_tile := Vector2i((global_position / TILE_SIZE).floor())
	
	if player_tile != current_tile or dir != last_facing:
		current_tile = player_tile
		last_facing = dir
	
		var target_tile := current_tile + Vector2i(dir)
		var target_center := Vector2(target_tile) * TILE_SIZE + Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)
		interaction_point.global_position = target_center

func snap_to_tile_center(world_pos: Vector2) -> Vector2:
	var tile_coord = (world_pos / TILE_SIZE).floor()
	return (tile_coord * TILE_SIZE) + Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)

func make_action():
	if Input.is_action_just_pressed("Action") and current_object:
		current_object.interact(self)
		
func update_animation():
	pointer_sprite.play("default")
	
	var is_running = Input.is_action_pressed("run") and velocity != Vector2.ZERO
	var is_holding = held_item != null

	# Idle
	if velocity == Vector2.ZERO:
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
		return

	# Determine prefix
	var prefix = "walk"
	if is_holding and is_running:
		prefix = "hold_run"
	elif is_holding:
		prefix = "hold_walk"
	elif is_running:
		prefix = "run"

	# Directional
	if abs(velocity.x) > abs(velocity.y):
		play_layers(prefix + "_right")
		flip_layers(velocity.x < 0)
		if is_holding:
			held_item.set_hold_direction("right", velocity.x < 0)
	else:
		if velocity.y < 0:
			play_layers(prefix + "_up")
			flip_layers(false)
			if is_holding:
				held_item.set_hold_direction("up", false)
		else:
			play_layers(prefix + "_down")
			flip_layers(false)
			if is_holding:
				held_item.set_hold_direction("down", false)

func set_held_item(item):
	held_item = item
	if held_item:
		var dir = "down"
		if skin.animation.contains("up"):
			dir = "up"
		elif skin.animation.contains("right"):
			dir = "right"
		held_item.set_hold_direction(dir, skin.flip_h)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("clickable"):
		current_object = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("clickable"):
		current_object = null
