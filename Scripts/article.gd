extends StaticBody2D

@export var article_data: ArticleData

var holder: Node2D = null
var kitchen_layer: TileMapLayer

func _ready() -> void:
	kitchen_layer = get_tree().get_first_node_in_group("clickable_tile")

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

func drop():
	holder = null
	
	if kitchen_layer:
		kitchen_layer.set_tile_occupied(global_position, true)
