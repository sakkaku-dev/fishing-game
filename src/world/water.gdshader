shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0);

uniform float waveSmoothing = .1;
uniform float mainWaveSpeed = 2.5;
uniform float mainWaveFrequency = 20;
uniform float mainWaveAmplitude = 0.01;

uniform float foamSize : hint_range(0., 1.0) = 0.0025;
uniform float sfoamStrength : hint_range(0., 1.0) = 0.5;
uniform float foamSpeed;
uniform vec2 foamScale;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	color = mix(color, tint, 0.3);
	color = mix(vec4(0.5), color, 1.4);
	
//
//	float distFromTop = 0.1; //mainWaveAmplitude * sin(UV.x * mainWaveFrequency + TIME * mainWaveSpeed) + mainWaveAmplitude;
//	float waveArea = UV.y - distFromTop;
//	waveArea = smoothstep(0., 1. * waveSmoothing, waveArea);
//
//	color.a *= waveArea;
	
	COLOR = color;
}