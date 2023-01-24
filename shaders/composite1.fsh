#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
in vec2 uv;

const float gaussian_15[15] = float[](
   0.00006103515625,
   0.0008544921875,
   0.00555419921875,
   0.022216796875,
   0.06109619140625,
   0.1221923828125,
   0.18328857421875,
   0.20947265625,
   0.18328857421875,
   0.1221923828125,
   0.06109619140625,
   0.022216796875,
   0.00555419921875,
   0.0008544921875,
   0.00006103515625
);

/* RENDERTARGETS:1 */
void main() {

	vec3 color = vec3(0.0);
	for(int y = 0; y < 15; y++) {
		vec2 offset = pixelSize * vec2(0.0, y - 7) * BLOOM_SIZE;
		color += texture2D(colortex0, uv + offset).rgb * gaussian_15[y];
	}
	// color /= 15;

	gl_FragData[0] = vec4(color, 1.0);
}