extends StaticBody2D

@export var new_object: PackedScene

@onready var order_object: Node2D = $"../OrderObject"

func interact(player):
	if new_object:
		var obj = new_object.instantiate()
		order_object.add_child(obj)
		obj.global_position = player.global_position
		obj.pickup(player)
		
		print("Objeto creado")
