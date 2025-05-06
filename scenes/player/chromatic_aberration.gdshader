shader_type canvas_item;

uniform sampler2D offset_texture;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear;
uniform float aberration : hint_range(0.0, 1.5, 0.001) = 0.5;
uniform float strength : hint_range(0.0, 1.0, 0.001) = 0.05;

void fragment() {
	vec2 suv = SCREEN_UV;
	vec2 resolution = vec2(textureSize(screen_tex, 0)); // Gets screen resolution
	vec2 offset_uv = UV * resolution / vec2(1920.0, 1080.0); // Scale offset_texture to screen size

	// Normalize screen UV and scale offset
	vec2 from_center = suv - vec2(0.5);
	vec2 aberration_vec = normalize(from_center) * aberration * strength;

	// Sample the offset texture, which should be white (1.0) on the edges and black (0.0) in the center
	float mask = texture(offset_texture, offset_uv).r;
	float adjusted_amount = mask * strength;

	// Apply chromatic shift
	vec4 red = texture(screen_tex, suv - aberration_vec * adjusted_amount);
	vec4 green = texture(screen_tex, suv + aberration_vec * adjusted_amount);
	vec4 blue = texture(screen_tex, suv);

	COLOR = vec4(red.r, green.g, blue.b, 1.0);
}
