shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float pixel_size : hint_range(1.0, 128.0) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
    
    // Redondear UV al tamaño de píxel actual
    vec2 pixelated_uv = floor(uv * resolution / pixel_size) * pixel_size / resolution;
    
    COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
