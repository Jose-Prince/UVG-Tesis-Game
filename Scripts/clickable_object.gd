extends StaticBody2D

@export var new_object: PackedScene

func interact(player):
	if new_object:
		var obj = new_object.instantiate()
		player.add_child(obj)
			
		print("Objeto creado")
