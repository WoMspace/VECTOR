#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
in vec2 uv;

uniform float far;

/* RENDERTARGETS:0 */
void main() {

	vec3 color = vec3(0.0);
	// for(int y = 0; y < 3; y++) {
	// 	for(int x = 0; x < 3; x++) {
	// 		vec2 offset = pixelSize * vec2(x - 1, y - 1) * 1.0;
	// 		vec3 tmp = texture2D(colortex0, uv + offset).rgb;
	// 		color = max(color, tmp);
	// 	}
	// }
	#ifdef THICKER_LINES
		color = texture2D(colortex0, uv).rgb;
		vec2 offset = pixelSize * vec2(0, 1);
		color = max(color, texture2D(colortex0, uv + offset).rgb);
		offset = pixelSize * vec2(0, -1);
		color = max(color, texture2D(colortex0, uv + offset).rgb);
		offset = pixelSize * vec2(1, 0);
		color = max(color, texture2D(colortex0, uv + offset).rgb);
		offset = pixelSize * vec2(-1, 0);
		color = max(color, texture2D(colortex0, uv + offset).rgb);
	#else
		color = texture2D(colortex0, uv).rgb;
	#endif

	vec3 bg = vec3(0.0);
	#ifdef MONOCHROME
	bg = USER_COLOR * 0.03;
	#endif
	float colorBrightness = dot(color, vec3(1.0));
	color = colorBrightness > 0.01 ? color : bg;

	#ifdef SCANLINES
	int scanline = int(gl_FragCoord.y) % 3;
	color *= scanline == 0 ? 0.0 : 1.0;
	#endif
	
	// color = texture2D(colortex0, uv).rgb;

	gl_FragData[0] = vec4(color, 1.0);
}