extends Node2D

const ITEM_SIZE := Vector2(24, 24)
const PADDING := Vector2(6, 6)
const ITEM_SPACING := 4

@onready var bubble_panel: NinePatchRect = $BubblePanel
@onready var item_container: HBoxContainer = $ItemContainer

func _ready() -> void:
	visible = false
	item_container.add_theme_constant_override("separation", ITEM_SPACING)

func show_order(items: Array) -> void:
	print(item_container.get_child_count())
	# clear previous icons
	for child in item_container.get_children():
		child.queue_free()

	# add one icon per item
	for item in items:
		var slot := TextureRect.new()
		slot.custom_minimum_size = ITEM_SIZE
		slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot.texture = item.image
		item_container.add_child(slot)

	# wait one frame for HBoxContainer to calculate its size
	await get_tree().process_frame

	# resize panel around content
	var content_size := item_container.size
	bubble_panel.size = content_size + PADDING * 2

	# center bubble horizontally, sit above character
	bubble_panel.position = Vector2(
		-bubble_panel.size.x / 2.0,
		-bubble_panel.size.y
	)

	# position icons inside panel with padding
	item_container.position = bubble_panel.position + PADDING

	visible = true

func hide_order() -> void:
	visible = false
