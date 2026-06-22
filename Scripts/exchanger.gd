extends StaticBody2D

@export var object_to_give: PackedScene
@export var object_to_get: PackedScene

@onready var order_object: Node2D = $"../OrderObject"

func interact(player):
	if order_object.get_child_count() == 0:
		return
	
	var current_object = order_object.get_child(0)
	
	if current_object.scene_file_path == object_to_give.resource_path:
		current_object.queue_free()
		
		if object_to_get:
			var new_obj = object_to_get.instantiate()
			order_object.add_child(new_obj)
			new_obj.global_position = global_position
			
			if new_obj.has_method("pickup"):
				new_obj.pickup(player)
			
			SfxManager.play_liquid()
			print("Objeto intercambiado")

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
