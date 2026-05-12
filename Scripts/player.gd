extends CharacterBody2D

@export var speed : float = 400.0

var current_object = null

func _physics_process(delta: float) -> void:
	get_input()
	make_action()
	move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func make_action():
	if Input.is_action_just_pressed("Action") and current_object:
		current_object.interact()
		
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("clickable"):
		current_object = body

func _on_detection_area_body_exited(body: Node2D) -> void:
		if body.is_in_group("clickable"):
			current_object = null
