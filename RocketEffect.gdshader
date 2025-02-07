shader_type canvas_item;

uniform sampler2D noise_tex1: repeat_enable;
uniform sampler2D noise_tex2: repeat_enable;

uniform vec3 yellow_color: source_color;
uniform vec3 orange_color: source_color;
uniform float effect_speed = 0.1;


// Height controls
uniform float flame_height = 1.2;

float ellipse(vec2 coord, float a, float b) {
	float x2 = pow(coord.x - 0.5, 2.0);
	float y2 = pow(coord.y + 0.6, 2.0);

	float val = x2/pow(a, 2.0) + y2/pow(b, 2.0);
	return val;
}
float soft_light(float base, float blend){
	float limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

float get_flame_noise(vec2 uv) {
	float noise1 = texture(noise_tex1, vec2(uv.x, uv.y - TIME * effect_speed)).r;
	float noise2 = texture(noise_tex1, vec2(uv.x, uv.y - TIME * effect_speed)).r;
	float smoke = soft_light(noise1, noise2);
	return smoke;
}


void fragment() {
	float main_flame = ellipse(UV, 0.15, flame_height);
	vec3 color = orange_color;
	if(main_flame < 0.7) {
		color = yellow_color;
	} else if(main_flame > 0.7 && main_flame < 0.9) {
		float s = smoothstep(0.1, 0.3, main_flame);
		color = mix(yellow_color, orange_color, s);
	}

	float smoke_mix_factor = smoothstep(0.4, 0.7, UV.y);
	float x_blend = smoothstep(0.0, 0.25, abs(UV.x - 0.5));
	smoke_mix_factor = mix(smoke_mix_factor, 0.0, x_blend);
	float flame = get_flame_noise(UV);
	color = mix(color, orange_color * flame, smoke_mix_factor);
	float bottom_fade = smoothstep(0.0, 0.1, UV.y);
	float alpha = mix(1.0 - main_flame, flame, smoke_mix_factor) * bottom_fade;
	COLOR.rgb = color;
	COLOR.a = alpha;
}
