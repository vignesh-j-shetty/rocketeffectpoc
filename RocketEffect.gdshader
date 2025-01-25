shader_type canvas_item;

uniform vec3 core_color: source_color = vec3(1.0);
uniform vec3 outer_flame_color: source_color = vec3(1.0);
uniform vec3 smoke_color: source_color = vec3(1.0);
uniform vec3 yellow_color: source_color = vec3(1.0);
uniform sampler2D noise_tex1: repeat_enable;
uniform sampler2D noise_tex2: repeat_enable;

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

float get_smoke_noise(vec2 uv) {
	float noise1 = texture(noise_tex1, vec2(uv.x, uv.y - TIME * 0.2)).r;
	float noise2 = texture(noise_tex1, vec2(uv.x, uv.y - TIME * 0.3)).r;
	float x_center_diff = abs(0.5 - uv.x);

	float smoke = soft_light(noise1, noise2);
	smoke = soft_light(smoothstep(0.3, 1.8, 1.0 - x_center_diff), smoke);
	smoke = smoke/smoothstep(0.0, 0.001, x_center_diff);
	return smoke;
}


void fragment() {
	//// Draw Exhaust
	//float exhaust = 1.0 - ellipse(UV, 0.3, 1.2);
	//exhaust = exhaust/(smoothstep(0.0, 1.5, 1.0 - UV.y));
//
	//float smoke_area = ellipse(UV, 0.22, 1.8);
	//float mask = smoothstep(0.2, 0.9, smoke_area);
	//float smoke_noise = get_smoke_noise(UV);
	//smoke_noise = smoke_noise/UV.y;
	//COLOR.rgb = mix(smoke_color * smoke_noise, outer_flame_color, smoothstep(0.3, 0.8, exhaust));
	//COLOR.a = max(exhaust, 1.0 - smoke_area);
	
	float exhaust = 1.0 - ellipse(UV, 0.3, 1.2);
	vec3 color = mix(outer_flame_color,core_color, smoothstep(0.0, 0.7, exhaust));
	if(exhaust <= 0.7)
	color = mix(color, yellow_color, smoothstep(0.6, 0.7, exhaust));
	COLOR.rgb = color;
	COLOR.a  = exhaust;
}
