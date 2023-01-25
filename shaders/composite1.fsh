#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
in vec2 uv;

uniform float far;

// from Builderb0y
vec2 distort(vec2 coord, float strength) {
	coord -= vec2(0.5);
	coord *= 1.0 - strength * dot(coord, coord);
	return coord + vec2(0.5);
}

/* RENDERTARGETS:0 */
void main() {
	vec2 uv_curved = uv;
	#ifdef CURVATURE
		uv_curved = distort(uv, -0.5);
		uv_curved = uv_curved * 2.0 - 1.0;
		uv_curved *= 0.85;
		uv_curved = uv_curved * 0.5 + 0.5;
	#endif

	vec3 color = vec3(0.0);
	#ifdef THICKER_LINES
		color = texture2D(colortex0, uv_curved).rgb;
		vec2 offset = pixelSize * vec2(0, 1);
		color = max(color, texture2D(colortex0, uv_curved + offset).rgb);
		offset = pixelSize * vec2(0, -1);
		color = max(color, texture2D(colortex0, uv_curved + offset).rgb);
		offset = pixelSize * vec2(1, 0);
		color = max(color, texture2D(colortex0, uv_curved + offset).rgb);
		offset = pixelSize * vec2(-1, 0);
		color = max(color, texture2D(colortex0, uv_curved + offset).rgb);
	#else
		color = texture2D(colortex0, uv_curved).rgb;
	#endif

	vec3 bg = vec3(0.0);
	#ifdef MONOCHROME
	bg = USER_COLOR * 0.03;
	#endif
	float colorBrightness = dot(color, vec3(1.0));
	color = colorBrightness > 0.01 ? color : bg;

	#ifdef CURVATURE
	if(uv_curved.x < 0.0 || uv_curved.x > 1.0) { color = vec3(0.0); }
	if(uv_curved.y < 0.0 || uv_curved.y > 1.0) { color = vec3(0.0); }
	#endif

	#ifdef SCANLINES
	int scanline = int(gl_FragCoord.y) % 3;
	color *= scanline == 0 ? 0.0 : 1.0;
	#endif
	
	// color = texture2D(colortex0, uv).rgb;

	gl_FragData[0] = vec4(color, 1.0);
}