shader_type canvas_item;

uniform float lod: hint_range(0.0, 5.0) = 5.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(TEXTURE, SCREEN_UV, lod);
}
