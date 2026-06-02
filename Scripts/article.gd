extends StaticBody2D

@export var price: int = 2
@export var hold_offset := Vector2.ZERO

var holder: Node2D = null

func _process(delta: float) -> void:
	z_index = int(global_position.y + 2)
	if holder:
		global_position = (holder.global_position + hold_offset)

func get_price():
	return price

func pickup(new_holder: Node2D):
	holder = new_holder

func drop():
	holder = null
