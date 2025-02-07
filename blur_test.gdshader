shader_type canvas_item;


uniform float sigma = 10.2;
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

float gauss(float x, float y) {
	float c = 2.0 * sigma * sigma;
	float p = (pow(x, 2) + pow(y, 2)) / c;
	float e = pow(E, -p);
	float g = 1.0 / (c * PI);
	return g * e;
}


void fragment() {
	int d = 5; // Kernel radius
	vec4 accumulated_color = vec4(0.0);
	float total_weight = 0.0;
	for (int i = -d; i <= d; i++) {
		for (int j = -d; j <= d; j++) {
			vec2 offset = vec2(float(i), float(j)) * SCREEN_PIXEL_SIZE;
			float weight = gauss(float(i), float(j));
			accumulated_color += (textureLod(screen_texture, SCREEN_UV + offset, 0.0) * weight);
			total_weight += weight;
		}
	}
	COLOR = accumulated_color / total_weight;  // Normalize by total weight
}