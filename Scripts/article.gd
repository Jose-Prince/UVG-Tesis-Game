extends StaticBody2D

@export var article_data: ArticleData
@export var hold_offset_down := Vector2(0, 10)
@export var hold_offset_right := Vector2(5, 10)
@export var hold_offset_up := Vector2(0, 10)

var current_offset := Vector2.ZERO

var holder: Node2D = null
var kitchen_layer: TileMapLayer

func _ready() -> void:
	kitchen_layer = get_tree().get_first_node_in_group("clickable_tile")

func set_hold_direction(dir: String, flipped: bool):
	match dir:
		"down":
			current_offset = hold_offset_down
		"right":
			current_offset = hold_offset_right
			if flipped:
				current_offset.x = -current_offset.x
		"up":
			current_offset = hold_offset_up
			visible = false
			return
	visible = true

func _process(delta: float) -> void:
	z_index = int(global_position.y + 2)
	if holder:
		global_position = (holder.global_position)

func get_price():
	return article_data.price

func get_article_name():
	return article_data.name

func pickup(new_holder: Node2D):
	holder = new_holder
	if new_holder.has_method("set_held_item"):
		new_holder.set_held_item(self)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

func drop():
	if holder and holder.has_method("set_held_item"):
		holder.set_held_item(null)
	holder = null
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	if kitchen_layer:
		kitchen_layer.set_tile_occupied(global_position, true)
