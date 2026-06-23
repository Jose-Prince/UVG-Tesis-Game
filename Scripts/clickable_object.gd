extends StaticBody2D

@export var new_object: PackedScene

@onready var order_object: Node2D = $"../OrderObject"

func interact(player):
	if new_object && !order_object.get_child(0):
		var obj = new_object.instantiate()
		order_object.add_child(obj)
		obj.global_position = player.global_position
		obj.pickup(player)
		
		if self.name == "CoffeeMaker":
			SfxManager.play_liquid()
		
		else:
			SfxManager.play_pick()
		print("Objeto creado")

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
