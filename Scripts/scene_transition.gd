extends CanvasLayer

var shader_material: ShaderMaterial

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.color.a = 0.0
	shader_material = color_rect.material as ShaderMaterial

# --------------
# FADE ANIMATION
# --------------

func fade(target_alpha: float, duration: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_alpha, duration)
	return tween

# ----------
# PIXELATION
# ----------

func pixelate_in(duration: float = 0.4) -> Tween:
	var tween := create_tween()
	tween.tween_method(set_pixel_size, 1.0, 64.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	return tween

func pixelate_out(duration: float = 0.4) -> Tween:
	var tween := create_tween()
	tween.tween_method(set_pixel_size, 64.0, 1.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	return tween

func change_scene_with_pixelation(scene_path: String):
	await pixelate_in(1.0).finished
	get_tree().change_scene_to_file(scene_path)
	#await get_tree().process_frame
	#await pixelate_out().finished

func set_pixel_size(value: float) -> void:
	if shader_material:
		shader_material.set_shader_parameter("pixel_size", value)
