shader_type canvas_item;

//uniform bool apply = true;
//uniform float amount = 1.0;
uniform sampler2D offset_texture;
uniform sampler2D screen_tex: hint_screen_texture, filter_linear;
uniform float aberration: hint_range(0.0, 1.5, 0.001) = 0.5;
uniform float strength: hint_range(0.0, 01., 0.001) = 0.05;

void fragment() {
	vec2 suv = SCREEN_UV;
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 scaled_suv = (suv - vec2(0.0,0.5) / vec2(1.0, aspect_ratio) + vec2(0, 0.5));
	vec2 offset = normalize(scaled_suv) * strength;
	vec2 aberration_vec = offset*aberration*strength;
	
	float adjusted_amount = texture(offset_texture, UV).r / 100.0;
	
	vec4 red = texture(screen_tex, suv - aberration_vec );
	vec4 green = texture(screen_tex, suv + aberration_vec );
	vec4 blue = texture(screen_tex, suv);
	
	COLOR = vec4(red.r, green.g, blue.b, 1.0);
}

	//vec4 texture_color = texture(TEXTURE, UV);
	//vec4 color = texture_color;
	//
	//if (apply == true) {
		//float adjusted_amount = amount * texture(offset_texture, UV).r / 100.0;
		//color.r = texture(TEXTURE, vec2(UV.x + adjusted_amount, UV.y)).r;
		//color.g = texture(TEXTURE, UV).g;
		//color.b = texture(TEXTURE, vec2(UV.x - adjusted_amount, UV.y)).b;
	//}
	//COLOR = color;