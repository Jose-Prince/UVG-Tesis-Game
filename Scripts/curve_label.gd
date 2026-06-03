@tool
class_name CurvedLabel extends Control

enum CurveMode {
	CIRCULAR,
	ARC_UP,
	ARC_DOWN,
	STRAIGHT
}

@export var text: String = "Curved Label" :
	set(value):
		text = value
		_update()
	get:
		return text
		
@export var curve_mode: CurveMode = CurveMode.CIRCULAR:
	set(value):
		curve_mode = value
		_update()
	get:
		return curve_mode

@export_group("Circular Mode")
@export var radius: float = 120.0:
	set(value):
		radius = value
		_update()
	get:
		return radius
		
@export_range(0.0, 360.0, 0.1)
var arc_degrees: float = 180.0:
	set(value):
		arc_degrees = value
		_update()
	get:
		return arc_degrees
		
@export_range(-180.0, 360.0, 0.1)
var start_angle_degrees: float = -90.0:
	set(value):
		start_angle_degrees = value
		_update()
	get:
		return start_angle_degrees
	
@export var clockwise: bool = false:
	set(value):
		clockwise = value
		_update()
	get:
		return clockwise

@export var center_offset: Vector2 = Vector2.ZERO:
	set(value):
		center_offset = value
		_update()
	get:
		return center_offset

@export_group("Arc Mode")
@export var curve_strength: float = 50.0:
	set(value):
		curve_strength = value
		_update()
	get:
		return curve_strength

@export var text_width: float = 300.0:
	set(value):
		text_width = value
		_update()
	get:
		return text_width

@export_group("Common")
@export var char_spacing: float = 0.0:
	set(value):
		char_spacing = value
		_update()
	get:
		return char_spacing

@export var orient_to_tangent: bool = true:
	set(value):
		orient_to_tangent = value
		_update()
	get:
		return orient_to_tangent 

@export var font: Font:
	set(value):
		font = value
		_update()
	get:
		return font

@export var label_settings: LabelSettings:
	set(value):
		label_settings = value
		_update()
	get:
		return label_settings

func _ready() -> void:
	_update()
	
func _clear_chars() -> void:
	for c: Node in get_children():
		c.queue_free()
		
func _update():
	_clear_chars()
	if text == "":
		return
		
	match curve_mode:
		CurveMode.CIRCULAR:
			_update_circular()
		CurveMode.ARC_UP:
			_update_arc(1.0)
		CurveMode.ARC_DOWN:
			_update_arc(-1.0)
		CurveMode.STRAIGHT:
			_update_straight()

func _update_circular():
	var chars: Array[String] = []
	for c: String in text:
		chars.append(str(c))
	var count: int = chars.size()
	if count == 0:
		return
	
	var step: float = (arc_degrees / max(count - 1, 1)) + char_spacing
	var dir: float = -1.0 if clockwise else 1.0
	var center: Vector2 = size * 0.5 + center_offset
	
	for i: int in count:
		var angle: float = start_angle_degrees  + step * i * dir
		var rad: float = deg_to_rad(angle)
		var pos: Vector2 = center + Vector2(cos(rad), sin(rad)) * radius
		
		var lbl: Label = Label.new()
		lbl.text = chars[i]
		if label_settings:
			lbl.label_settings = label_settings
		elif font:
			lbl.add_theme_font_override("font", font)
		add_child(lbl)
		lbl.reset_size()
		lbl.pivot_offset = lbl.size * 0.5
		lbl.position = pos - lbl.pivot_offset
		
		if orient_to_tangent:
			lbl.rotation_degrees = angle + 90.0 * dir

func _update_arc(direction: float) -> void:
	var chars: Array[String] = []
	for c: String in text:
		chars.append(str(c))
	var count: int = chars.size()
	if count == 0:
		return
		
	var total_spacing: float = char_spacing * (count - 1)
	var effective_width: float = text_width + total_spacing
	
	var start_x: float = (size.x - effective_width) * 0.5
	var base_y: float = size.y * 0.5
	
	for i: int in count:
		var t: float = float(i)  /max(count - 1, 1)
		var x: float = start_x + t * effective_width
		
		var curve_t: float = (t - 0.5) * 2.0
		var y: float = base_y + direction * curve_strength * (1.0 - curve_t * curve_t)
		
		var lbl: Label = Label.new()
		lbl.text = chars[i]
		if label_settings:
			lbl.label_settings = label_settings
		elif font:
			lbl.add_theme_font_override("font", font)
		add_child(lbl)
		lbl.reset_size()
		lbl.pivot_offset = lbl.size * 0.5
		lbl.position = Vector2(x, y) - lbl.pivot_offset
		
		if orient_to_tangent:
			var derivative: float = -direction * 4.0 * curve_strength * curve_t / effective_width
			lbl.rotation = atan(derivative)

func _update_straight() -> void:
	var chars: Array[String] = []
	for c: String in text:
		chars.append(str(c))
	var count: int = chars.size()
	if count == 0:
		return
		
	var total_spacing: float = char_spacing * (count - 1)
	var effective_width: float = text_width + total_spacing
	
	var start_x: float = (size.x - effective_width) * 0.5
	var y: float = size.y * 0.5
	
	for i: int in count:
		var t: float = float(i) / max(count - 1, 1)
		var x: float = start_x + t * effective_width
		
		var lbl: Label = Label.new()
		lbl.text = chars[i]
		if label_settings:
			lbl.label_settings = label_settings
		elif font:
			lbl.add_theme_font_override("font", font)
		add_child(lbl)
		lbl.reset_size()
		lbl.pivot_offset = lbl.size * 0.5
		lbl.position = Vector2(x, y) - lbl.pivot_offset
		
func _notification(what: int) -> void:
	if Engine.is_editor_hint() && what == NOTIFICATION_PROCESS:
		_update()
