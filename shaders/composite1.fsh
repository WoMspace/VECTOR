#version 150 compatibility

#include "/lib/settings.h"
#include "/lib/text.glsl"

uniform sampler2D colortex0;
in vec2 uv;

uniform float far;
uniform float frameTimeCounter;

// from Builderb0y
vec2 distort(vec2 coord) {
	const vec2 CURVATURE = vec2(CURVATURE_X, CURVATURE_Y);
	const vec2 BARREL_SCALE = 1.0 - (0.23 * CURVATURE);
	coord -= 0.5;
	coord *= 1.0 + CURVATURE * dot(coord, coord);
	coord *= BARREL_SCALE;
	return coord + 0.5;
}

/* RENDERTARGETS:0 */
void main() {
	vec2 uv_curved = distort(uv);

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

	float colorBrightness = dot(color, vec3(1.0));
	color = colorBrightness > 0.01 ? color : USER_BG_COLOR;

	if(uv_curved.x < 0.0 || uv_curved.x > 1.0) { color = vec3(0.0); }
	if(uv_curved.y < 0.0 || uv_curved.y > 1.0) { color = vec3(0.0); }

	#ifdef SCANLINES
		bool scanline = int(gl_FragCoord.y) % 3 == 0;
		
		#if SCAN_SIZE != 0
			int scan_speed = int(viewHeight) / SCAN_SPEED;
			int currentScanLine = int(viewHeight) - int(frameTimeCounter * scan_speed) % int(viewHeight);
			int proximityToCurrentLine = SCAN_SIZE - clamp(abs(int(gl_FragCoord.y) - currentScanLine), 0, SCAN_SIZE);
			float brightnessMul = float(proximityToCurrentLine) / float(SCAN_SIZE) + 1.0;
			color *= scanline ? 0.0 : brightnessMul;
		#else
			color *= scanline ? 0.0 : 1.0;
		#endif


		// color = vec3(0.0, brightnessMul - 1.0, 0.0);
		// color = int(gl_FragCoord.y) == currentScanLine ? vec3(1.0, 0.0, 0.0) : color;
	#endif
	
	// color = texture2D(colortex0, uv).rgb;

	gl_FragData[0] = vec4(color, 1.0);
}