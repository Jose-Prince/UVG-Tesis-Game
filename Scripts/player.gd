extends CharacterBody2D

@export var speed : float = 400.0
@export var run_speed : float = 650.0

var player_name := ""
var current_object = null

func _physics_process(delta: float) -> void:
	get_input()
	make_action()
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
		
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("clickable"):
		current_object = body

func _on_detection_area_body_exited(body: Node2D) -> void:
		if body.is_in_group("clickable"):
			current_object = null
