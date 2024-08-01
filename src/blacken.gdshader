shader_type canvas_item;

uniform bool enabled = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (enabled) {
		COLOR.rgb = vec3(0., 0., 0.);
	}
}
