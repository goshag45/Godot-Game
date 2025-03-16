shader_type spatial;

uniform float fill_amount : hint_range(0.0, 1.0); // HP % (0 = empty, 1 = full)
uniform vec4 blood_color = vec4(1.0, 0.0, 0.0, 1.0); // Default: Red

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec3 world_pos = VERTEX; // Get the world position of the fragment
	//float height = world_pos.y; // Extract Y position
	//float cutoff = mix(-0.5, 0.5, fill_amount); // Map fill_amount to object height

	//if (height < cutoff) {
		//discard; // Clip the pixels below the blood level
	//}

	ALBEDO = blood_color.rgb;
	ALPHA = blood_color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
