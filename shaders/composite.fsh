#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
in vec2 uv;

const float edge_kernel[9] = float[](-1.0, -1.0, -1.0, -1.0, 8.0, -1.0, -1.0, -1.0, -1.0);

/* RENDERTARGETS:0 */
void main() {
	
	vec3 color = vec3(0.0);
	for(int y = 0; y < 3; y++) {
		for(int x = 0; x < 3; x++) {
			vec2 offset = pixelSize * vec2(x - 1.0, y - 1.0) * 1.0;
			color += texture2D(colortex0, uv + offset).rgb * edge_kernel[y * 3 + x];
		}
	}
	color /= 4.5;

	float lineStrength = dot(color, vec3(0.21, 0.72, 0.07));
	lineStrength = lineStrength > LINE_THRESHOLD ? 1.0 : 0.0;

	// color = vec3(LINE_COLOR_R, LINE_COLOR_G, LINE_COLOR_B) * lineStrength;
	color = normalize(color) * lineStrength;

	gl_FragData[0] = vec4(color, 1.0);
}