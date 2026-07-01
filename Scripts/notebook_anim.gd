extends TextureRect

@export var animation_duration := 1.0

var initial_size_x := 816.0
var initial_size_y := 824.0
var initial_position_x := 88.0
var initial_position_y := 12.0
var initial_anchor_point_left := 0.076
var initial_anchor_point_top := 0.019
var initial_anchor_point_right := 0.785
var initial_anchor_point_bottom := 1.29
var initial_anchor_offset_left := 0
var initial_anchor_offset_top := 0
var initial_anchor_offset_right := 0
var initial_anchor_offset_bottom := 0

func _ready() -> void:
	apply_initial_state()

func apply_initial_state():
	size = Vector2(initial_size_x, initial_size_y)
	position = Vector2(initial_position_x, initial_position_y)
	rotation_degrees = 0
	pivot_offset = Vector2.ZERO

	anchor_left = initial_anchor_point_left
	anchor_top = initial_anchor_point_top
	anchor_right = initial_anchor_point_right
	anchor_bottom = initial_anchor_point_bottom

	offset_left = initial_anchor_offset_left
	offset_top = initial_anchor_offset_top
	offset_right = initial_anchor_offset_right
	offset_bottom = initial_anchor_offset_bottom

func animate_to_desired():
	var viewport_size = get_viewport_rect().size

	# Al rotar -90°, ancho y alto se intercambian para cubrir toda la pantalla
	var target_size = Vector2(viewport_size.y, viewport_size.x)

	# Centrar en pantalla
	var target_position = Vector2(
		(viewport_size.x - target_size.x) / 2,
		(viewport_size.y - target_size.y) / 2
	)

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "size", target_size, animation_duration)
	tween.tween_property(self, "pivot_offset", target_size / 2, animation_duration)
	tween.tween_property(self, "position", target_position, animation_duration)
	tween.tween_property(self, "rotation_degrees", -90.0, animation_duration)

func _on_sound_menu_visibility_changed() -> void:
	animate_to_desired()
