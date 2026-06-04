# responsive_label.gd
# Adjunta este script a cualquier Label para que su fuente escale con la pantalla.
@tool
class_name ResponsiveLabel extends Label

enum ScaleMode {
	RELATIVE_TO_VIEWPORT,   # Escala según el ancho/alto de la ventana
	RELATIVE_TO_PARENT,     # Escala según el tamaño del nodo padre
	FIXED_STEPS,            # Tamaños predefinidos por breakpoints
}

@export var scale_mode: ScaleMode = ScaleMode.RELATIVE_TO_VIEWPORT:
	set(value):
		scale_mode = value
		_update_font_size()
	get:
		return scale_mode

@export_group("Relative Mode")
# Fracción del lado de referencia que usará como tamaño de fuente
@export_range(0.01, 0.2, 0.001)
var size_fraction: float = 0.05:
	set(value):
		size_fraction = value
		_update_font_size()
	get:
		return size_fraction

# Qué dimensión usar como referencia para escalar
enum ReferenceAxis { WIDTH, HEIGHT, MIN, MAX }
@export var reference_axis: ReferenceAxis = ReferenceAxis.WIDTH:
	set(value):
		reference_axis = value
		_update_font_size()
	get:
		return reference_axis

@export_group("Limits")
@export var min_font_size: int = 8:
	set(value):
		min_font_size = value
		_update_font_size()
	get:
		return min_font_size

@export var max_font_size: int = 256:
	set(value):
		max_font_size = value
		_update_font_size()
	get:
		return max_font_size

@export_group("Fixed Steps")
# Breakpoints: cada entrada es [ancho_minimo, tamaño_fuente]
# Ejemplo: [[0, 12], [768, 18], [1280, 24]]
@export var breakpoints: Array[Vector2] = [
	Vector2(0, 12),
	Vector2(768, 18),
	Vector2(1280, 24),
	Vector2(1920, 32),
]:
	set(value):
		breakpoints = value
		_update_font_size()
	get:
		return breakpoints

var _viewport: Viewport = null

func _ready() -> void:
	_viewport = get_viewport()
	if _viewport:
		_viewport.size_changed.connect(_on_viewport_resized)
	_update_font_size()

func _exit_tree() -> void:
	if _viewport and _viewport.size_changed.is_connected(_on_viewport_resized):
		_viewport.size_changed.disconnect(_on_viewport_resized)

func _on_viewport_resized() -> void:
	_update_font_size()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		if scale_mode == ScaleMode.RELATIVE_TO_PARENT:
			_update_font_size()
	if Engine.is_editor_hint() and what == NOTIFICATION_PROCESS:
		_update_font_size()

func _get_reference_size() -> float:
	match scale_mode:
		ScaleMode.RELATIVE_TO_VIEWPORT:
			var vp_size: Vector2 = get_viewport_rect().size
			return _axis_value(vp_size)
		ScaleMode.RELATIVE_TO_PARENT:
			var parent: CanvasItem = get_parent() as CanvasItem
			if parent is Control:
				return _axis_value((parent as Control).size)
			return _axis_value(get_viewport_rect().size)
		ScaleMode.FIXED_STEPS:
			return get_viewport_rect().size.x
	return get_viewport_rect().size.x

func _axis_value(s: Vector2) -> float:
	match reference_axis:
		ReferenceAxis.WIDTH:  return s.x
		ReferenceAxis.HEIGHT: return s.y
		ReferenceAxis.MIN:    return min(s.x, s.y)
		ReferenceAxis.MAX:    return max(s.x, s.y)
	return s.x

func _update_font_size() -> void:
	if not is_inside_tree():
		return

	var new_size: int

	if scale_mode == ScaleMode.FIXED_STEPS:
		new_size = _resolve_breakpoint()
	else:
		var ref: float = _get_reference_size()
		new_size = int(ref * size_fraction)

	new_size = clampi(new_size, min_font_size, max_font_size)
	add_theme_font_size_override("font_size", new_size)

func _resolve_breakpoint() -> int:
	if breakpoints.is_empty():
		return min_font_size

	var vp_width: float = get_viewport_rect().size.x

	# Ordenar por ancho mínimo y tomar el último que aplique
	var sorted: Array[Vector2] = breakpoints.duplicate()
	sorted.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.x < b.x)

	var result: int = int(sorted[0].y)
	for bp: Vector2 in sorted:
		if vp_width >= bp.x:
			result = int(bp.y)
	return result
