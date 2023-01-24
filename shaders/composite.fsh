#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
in vec2 uv;

uniform float far;

const float edge_kernel[9] = float[](-1.0, -1.0, -1.0, -1.0, 8.0, -1.0, -1.0, -1.0, -1.0);

float linearizeDepth(float nonLinear) {
	return pow(far + 1.0, nonLinear) - 1.0;
}

/* RENDERTARGETS:0 */
void main() {
	
	vec3 color = vec3(0.0);
	for(int y = 0; y < 3; y++) {
		for(int x = 0; x < 3; x++) {
			vec2 offset = pixelSize * vec2(x - 1, y - 1) * 1.0;
			color += texture2D(colortex0, uv + offset).rgb * edge_kernel[y * 3 + x];
		}
	}
	color /= 4.5;

	float depth = 0.0;
	for(int y = 0; y < 3; y++) {
		for(int x = 0; x < 3; x++) {
			vec2 offset = pixelSize * vec2(float(x) - 1.0, float(y) - 1.0) * 1.0;
			float rawDepth = texture2D(depthtex0, uv + offset).r;
			depth += linearizeDepth(rawDepth) * edge_kernel[y * 3 + x];
		}
	}
	depth /= 9.0;

	float grey = dot(color, vec3(0.21, 0.72, 0.07));

	float line = grey + depth > LINE_THRESHOLD ? 1.0 : 0.0;

	#ifdef MONOCHROME
	color = normalize(USER_COLOR) * line;
	#else
	color = normalize(color) * line;
	#endif

	// color = texture2D(colortex0, uv).rgb;

	gl_FragData[0] = vec4(color, 1.0);
}