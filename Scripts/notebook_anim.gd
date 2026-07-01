extends TextureRect

@export var animation_duration := 1.0

@export var margin_left_percent := 0.25
@export var margin_top_percent := 0.01
@export var margin_right_percent := 0.05
@export var margin_bottom_percent := 0.02

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

var is_desired := false

@onready var margin_container: MarginContainer = $"../MarginContainer"

func _ready() -> void:
	apply_initial_state()
	get_viewport().size_changed.connect(_on_viewport_size_changed)

func apply_initial_state():
	is_desired = false
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
	is_desired = true
	_apply_desired(true)

func _apply_desired(animated: bool):
	var viewport_size = get_viewport_rect().size
	var target_size = Vector2(viewport_size.y, viewport_size.x)
	var target_position = Vector2(
		(viewport_size.x - target_size.x) / 2,
		(viewport_size.y - target_size.y) / 2
	)

	var visible_width = viewport_size.y
	var visible_height = viewport_size.x

	var m_left = visible_width * margin_left_percent
	var m_top = visible_height * margin_top_percent
	var m_right = visible_width * margin_right_percent
	var m_bottom = visible_height * margin_bottom_percent

	if animated:
		var tween = create_tween()
		tween.set_parallel(true)

		tween.tween_property(self, "size", target_size, animation_duration)
		tween.tween_property(self, "pivot_offset", target_size / 2, animation_duration)
		tween.tween_property(self, "position", target_position, animation_duration)
		tween.tween_property(self, "rotation_degrees", -90.0, animation_duration)

		tween.tween_property(margin_container, "theme_override_constants/margin_left", m_left, animation_duration)
		tween.tween_property(margin_container, "theme_override_constants/margin_top", m_top, animation_duration)
		tween.tween_property(margin_container, "theme_override_constants/margin_right", m_right, animation_duration)
		tween.tween_property(margin_container, "theme_override_constants/margin_bottom", m_bottom, animation_duration)
	else:
		size = target_size
		pivot_offset = target_size / 2
		position = target_position
		rotation_degrees = -90.0

		margin_container.add_theme_constant_override("margin_left", m_left)
		margin_container.add_theme_constant_override("margin_top", m_top)
		margin_container.add_theme_constant_override("margin_right", m_right)
		margin_container.add_theme_constant_override("margin_bottom", m_bottom)

func _on_viewport_size_changed():
	if is_desired:
		_apply_desired(false)

func _on_sound_menu_visibility_changed() -> void:
	animate_to_desired()
