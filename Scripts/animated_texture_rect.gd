class_name AnimatedTextureRect
extends TextureRect

var current_frame := 0
var is_playing := false
var animation_loop := false

@export var sprite_list : Array[AtlasTexture]
@export var frame_duration := 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_animation(loop: bool = false) -> void:
	if sprite_list.is_empty():
		return
	
	if is_playing:
		return
	
	is_playing = true
	animation_loop = loop
	current_frame = 0
	
	while is_playing:
		texture = sprite_list[current_frame]
		
		await get_tree().create_timer(frame_duration).timeout
		
		current_frame += 1
		
		if current_frame >= sprite_list.size():
			if animation_loop:
				current_frame = 0
			else:
				is_playing = false
