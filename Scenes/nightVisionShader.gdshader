shader_type canvas_item;

uniform vec3 luminance: source_color = vec3(0.3086, 0.6094, 0.0820);
uniform vec3 base_color: source_color = vec3(0.2, 1.0, 0.4);

void fragment() {
	vec2 uv = UV - 0.5;
	vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	uv.x += resolution.x / resolution.y;
	float time = TIME;
	vec3 color = texture(TEXTURE, UV).rgb;
	vec3 vision_color = base_color;
	color = dot(color, luminance) * vision_color;
	COLOR = vec4(color, 1.0);
}
