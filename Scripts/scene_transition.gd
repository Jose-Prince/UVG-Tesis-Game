extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.color.a = 0.0

func fade(target_alpha: float, duration: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_alpha, duration)
	return tween

#@onready var overlay: ColorRect = $ColorRect
#var shader_material: ShaderMaterial
#
#func _ready():
	#SaveManager.day_ended.connect(transition)
	#shader_material = overlay.material as ShaderMaterial
#
## Pixelar → pantalla negra → despixelar
#func transition() -> void:
	#await pixelate_in()
	#get_tree().change_scene_to_file("res://Scenes/new_day.tscn")
	#await get_tree().process_frame
	#await pixelate_out()
#
#func pixelate_in() -> void:
	#var tween = create_tween()
	#tween.tween_method(set_pixel_size, 1.0, 64.0, 0.4)\
		 #.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	#await tween.finished
#
#func pixelate_out() -> void:
	#var tween = create_tween()
	#tween.tween_method(set_pixel_size, 64.0, 1.0, 0.4)\
		 #.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	#await tween.finished
#
#func set_pixel_size(value: float) -> void:
	#shader_material.set_shader_parameter("pixel_size", value)
