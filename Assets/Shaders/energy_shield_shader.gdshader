// Energy Shield Shader for Godot 4.5
// Transparent, glowing planetary shield (use on a sphere mesh around your planet)

shader_type spatial;

render_mode unshaded, cull_back, blend_add;

// --- Uniforms (tweak in the editor) ---
uniform vec4 albedo_color : source_color = vec4(0.0, 0.5, 1.0, 0.6);
uniform vec4 rim_color : source_color = vec4(0.5, 0.9, 1.0, 1.0);
uniform float rim_power : hint_range(0.1, 8.0) = 2.0;
uniform float fresnel_strength : hint_range(0.0, 5.0) = 2.5;
uniform float thickness : hint_range(0.0, 1.0) = 0.35;
uniform sampler2D noise_tex;
uniform float noise_scale : hint_range(0.1, 10.0) = 2.5;
uniform float noise_speed : hint_range(-4.0, 4.0) = 0.2;
uniform float scan_speed : hint_range(-4.0, 4.0) = 0.6;
uniform float scan_width : hint_range(0.001, 0.5) = 0.02;
uniform vec4 scan_color : source_color = vec4(1.0, 1.0, 1.0, 0.9);
uniform float overall_opacity : hint_range(0.0, 1.0) = 0.9;
uniform float edge_falloff : hint_range(0.0, 5.0) = 1.8;

// Pass data to fragment
varying vec3 world_pos_v;
varying vec3 world_normal_v;

void vertex() {
    world_pos_v = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_normal_v = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
    vec3 world_pos = world_pos_v;
    vec3 N = normalize(world_normal_v);

    // Compute camera world position
    vec3 camera_world_pos = (inverse(VIEW_MATRIX) * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

    vec3 view_dir = normalize(camera_world_pos - world_pos);

    // Fresnel rim
    float fresnel = pow(1.0 - max(dot(view_dir, N), 0.0), fresnel_strength);
    float band = smoothstep(0.0, thickness, fresnel);

    // Spherical UVs
    float azimuth = atan(world_pos.z, world_pos.x);
    float elevation = world_pos.y * 0.5 + 0.5;
    vec2 spherical_uv = vec2(azimuth / 6.28318530718 + 0.5, elevation);

    // Animate noise
    vec2 noise_uv = spherical_uv * noise_scale + vec2(noise_speed * TIME, 0.0);
    float noise = texture(noise_tex, noise_uv).r;
    band *= mix(0.85, 1.15, noise);

    // Scanline sweep
    float scan_pos = fract(spherical_uv.x + scan_speed * TIME);
    float scan_band = smoothstep(0.0, scan_width, abs(scan_pos - 0.5));
    scan_band = 1.0 - scan_band;

    // Combine effects
    vec3 base = albedo_color.rgb * albedo_color.a;
    vec3 rim = rim_color.rgb * pow(fresnel, rim_power);
    vec3 scan = scan_color.rgb * scan_band;
    float edge = pow(fresnel, edge_falloff);

    vec3 color = base * band * (0.5 + 0.5 * noise)
               + rim * (0.7 + 0.3 * noise)
               + scan * 1.2;

    float alpha = clamp(albedo_color.a * overall_opacity * (0.6 * band + 0.4 * edge), 0.0, 1.0);

    ALBEDO = color;
    ALPHA = alpha;
    EMISSION = color * alpha * 2.0;
}

/*
✅ Notes:
- Works in Godot 4.5 (no deprecated identifiers).
- If invisible from outside, switch to `render_mode unshaded, cull_front, blend_add`
  or `cull_disabled` for double-sided.
- Add a second larger sphere with lower opacity for a halo effect.
*/
