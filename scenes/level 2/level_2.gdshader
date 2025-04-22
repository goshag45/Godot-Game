// NOTE: Shader automatically converted from Godot Engine 4.4.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform sampler2D texture_emission : source_color, hint_default_black, filter_linear_mipmap, repeat_enable;
uniform vec4 emission : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.01);
varying vec3 uv1_triplanar_pos;

uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001);
varying vec3 uv1_power_normal;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float speed: hint_range(0.05, 0.5) = 0.1;
uniform float strength : hint_range(0.05, 0.5) = 0.1;
uniform sampler2D noise;
varying vec3 v_normal; // Pass normal to the fragment shader

void vertex() {
	vec3 normal = MODEL_NORMAL_MATRIX * NORMAL;
	v_normal = normal; // Store normal for fragment shader

	// Calculate animated noise
	vec2 noise_uv = VERTEX.xz * 0.5 + TIME * speed;
	float noise_value = texture(noise, noise_uv).r * 2.0 - 1.0;

	// Apply displacement along normal
	VERTEX += normal * noise_value * strength;

	// Triplanar Mapping
	TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
	TANGENT = inverse(MODEL_NORMAL_MATRIX) * normalize(TANGENT);

	BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
	BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
	BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
	BINORMAL = inverse(MODEL_NORMAL_MATRIX) * normalize(BINORMAL);

	uv1_power_normal = pow(abs(normal), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz * uv1_scale + uv1_offset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}


vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec4 samp = vec4(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	// Generate animated noise-based UV distortion
	vec2 noise_uv = uv1_triplanar_pos.xz * 0.5 + TIME * speed * 0.5;
	float noise_value = texture(noise, noise_uv).r * 2.0 - 1.0;

	// Apply distortion to the triplanar position using the passed normal
	vec3 distorted_triplanar_pos = uv1_triplanar_pos + v_normal * noise_value * strength * 0.5;

	// Sample albedo with distorted coordinates
	vec4 albedo_tex = triplanar_texture(texture_albedo, uv1_power_normal, distorted_triplanar_pos);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	// Sample metallic texture
	float metallic_tex = dot(triplanar_texture(texture_metallic, uv1_power_normal, distorted_triplanar_pos), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	// Sample roughness texture
	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(triplanar_texture(texture_roughness, uv1_power_normal, distorted_triplanar_pos), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;

	// Sample emission texture
	vec3 emission_tex = triplanar_texture(texture_emission, uv1_power_normal, distorted_triplanar_pos).rgb;
	EMISSION = (emission.rgb + emission_tex) * emission_energy;
}
