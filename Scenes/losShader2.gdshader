shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {

LIGHT.rgb = vec3(0);
if (LIGHT_COLOR == vec4(1)) {
	LIGHT = texture(SCREEN_TEXTURE, SCREEN_UV);
}
else
{
	LIGHT.rgb = vec3(0.5,0.1,0.9);
}

/*
LIGHT.rgb = vec3(0);
if (LIGHT_COLOR == vec4(1)) {
	LIGHT = texture(SCREEN_TEXTURE, SCREEN_UV);
}
*/
}
