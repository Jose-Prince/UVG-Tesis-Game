extends StaticBody2D

@export var article_data: ArticleData

var bob_offset := 0

var current_offset := Vector2.ZERO
var side_offset := Vector2(8, 0)

var holder: Node2D = null
var kitchen_layer: TileMapLayer
var flip = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	kitchen_layer = get_tree().get_first_node_in_group("clickable_tile")

func set_hold_direction(dir: String, flipped: bool):
	current_offset = Vector2.ZERO

	match dir:
		"down":
			animated_sprite_2d.flip_h = flip
			visible = true

		"right":
			visible = true

			animated_sprite_2d.flip_h = !flip
			current_offset = side_offset

			if flipped:
				animated_sprite_2d.flip_h = flip
				current_offset.x *= -1

		"up":
			visible = false
			return
	
func _process(delta):
	if holder:
		global_position = holder.global_position + current_offset
		global_position.y += bob_offset

		if holder.has_method("set_held_item"):
			z_index = holder.z_index + 10
		else:
			z_index = holder.z_index
	else:
		z_index = int(global_position.y)

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

func update_bob(anim_name: String, frame: int):
	if !anim_name.contains("walk") and !anim_name.contains("run"):
		bob_offset = 0
		return

	if anim_name.contains("walk"):
		match frame:
			1, 3:
				bob_offset = 0
			_:
				bob_offset = -1
	
	if anim_name.contains("run"):
		match frame:
			1, 3:
				bob_offset = -1
			_:
				bob_offset = 0

func is_giveable():
	return article_data
