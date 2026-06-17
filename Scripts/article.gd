extends StaticBody2D

@export var price: int = 2
@export var hold_offset := Vector2.ZERO

var holder: Node2D = null
var kitchen_layer: TileMapLayer

func _ready() -> void:
	kitchen_layer = get_tree().get_first_node_in_group("clickable_tile")

func _process(delta: float) -> void:
	z_index = int(global_position.y + 2)
	if holder:
		global_position = (holder.global_position + hold_offset)

func get_price():
	return price

func pickup(new_holder: Node2D):
	holder = new_holder
	if new_holder.has_method("set_held_item"):
		new_holder.set_held_item(self)

func drop():
	if holder and holder.has_method("set_held_item"):
		holder.set_held_item(null)
	holder = null
	
	if kitchen_layer:
		kitchen_layer.set_tile_occupied(global_position, true)
