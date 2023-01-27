#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0; // albedo
uniform sampler2D colortex3; // normals
uniform sampler2D depthtex0;
in vec2 uv;

uniform float far;
uniform float near;

const float edge_kernel[9] = float[](-1.0, -1.0, -1.0, -1.0, 8.0, -1.0, -1.0, -1.0, -1.0);

// Choc version
float linearizeDepth(float dist) {
    return (2.0 * near) / (far + near - dist * (far - near));
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
	depth *= 0.8;

	vec3 normal = vec3(0.0);
	for(int y = 0; y < 3; y++) {
		for(int x = 0; x < 3; x++) {
			vec2 offset = pixelSize * vec2(x - 1, y - 1) * 1.0;
			normal += texture2D(colortex3, uv + offset).rgb * edge_kernel[y * 3 + x];
		}
	}
	// normal /= 9.0;

	// Human brightness thing idk lol
	float grey = dot(color, vec3(0.21, 0.72, 0.07));
	float normalGrey = dot(abs(normal), vec3(1.0));

	float sobelLine = grey > LINE_THRESHOLD_CONTRAST ? 1.0 : 0.0;
	float depthLine = depth > LINE_THRESHOLD_DEPTH ? 1.0 : 0.0;
	float normalLine = normalGrey > LINE_THRESHOLD_NORMAL ? 1.0 : 0.0;
	float line = max(depthLine, sobelLine);
	line = max(line, normalLine);

	#ifdef MONOCHROME
	color = normalize(USER_COLOR) * line;
	#else
	color = normalize(color) * line;
	#endif

	// color = texture2D(colortex0, uv).rgb;
	// color = vec3(sobelLine);
	// color = texture2D(colortex3, uv).rgb;
	// color = normal;
	// color = vec3(normalLine);

	gl_FragData[0] = vec4(color, 1.0);
}