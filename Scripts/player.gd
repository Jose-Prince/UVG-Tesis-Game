extends CharacterBody2D

@export var speed : float = 400.0
@export var run_speed : float = 650.0

var player_name := ""
var current_object = null

@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float):
	z_index = int(global_position.y)
	if Input.is_action_just_pressed("Action") and DialogueBox.visible and !DialogueBox.is_typing and !DialogueBox.just_skipped:
		DialogueBox.hide_dialogue()

func _physics_process(delta: float) -> void:
	get_input()
	make_action()
	update_animation()
	move_and_slide()
	
func get_input():
	if DialogueBox.visible:
		velocity = Vector2.ZERO
		return
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	var current_speed = speed
	
	if Input.is_action_pressed("run"):
		current_speed = run_speed
	
	velocity = input_direction * current_speed

func make_action():
	if Input.is_action_just_pressed("Action") and current_object:
		current_object.interact(self)
		
func update_animation():
	# Idle
	if velocity == Vector2.ZERO:
		if animated_sprite.animation == "walk_up":
			animated_sprite.play("idle_up")
		elif animated_sprite.animation == "walk_right":
			animated_sprite.play("idle_right")
		else:
			animated_sprite.play("idle")
		return

	# Walking
	if abs(velocity.x) > abs(velocity.y):
		# Movimiento horizontal
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = velocity.x < 0
	else:
		# Movimiento vertical
		if velocity.y < 0:
			animated_sprite.play("walk_up")
		else:
			animated_sprite.play("walk_down")
		animated_sprite.flip_h = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("clickable"):
		current_object = body

func _on_detection_area_body_exited(body: Node2D) -> void:
		if body.is_in_group("clickable"):
			current_object = null
