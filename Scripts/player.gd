extends CharacterBody2D

@export var speed : float = 400.0
@export var run_speed : float = 650.0

var player_name := ""
var current_object = null

@onready var skin: AnimatedSprite2D = $skin
@onready var clothes: AnimatedSprite2D = $clothes
@onready var lineart: AnimatedSprite2D = $lineart
@onready var hair: AnimatedSprite2D = $hair

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
	z_index = int(global_position.y)

func _physics_process(delta: float) -> void:
	get_input()
	make_action()
	update_animation()
	move_and_slide()
	
func get_input():
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
		if skin.animation == "walk_up":
			play_layers("idle_up")
		elif skin.animation == "walk_right":
			play_layers("idle_right")
		else:
			play_layers("idle")
		return

	# Walking
	if abs(velocity.x) > abs(velocity.y):
		# Movimiento horizontal
		play_layers("walk_right")
		flip_layers(velocity.x < 0)
	else:
		# Movimiento vertical
		if velocity.y < 0:
			play_layers("walk_up")
		else:
			play_layers("walk_down")
		flip_layers(false)
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("clickable"):
		current_object = body

func _on_detection_area_body_exited(body: Node2D) -> void:
		if body.is_in_group("clickable"):
			current_object = null
