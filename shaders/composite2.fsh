#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex1;
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
	for(int x = 0; x < 15; x++) {
		vec2 offset = pixelSize * vec2(x - 7, 0.0) * BLOOM_SIZE;
		color += texture2D(colortex1, uv + offset).rgb * gaussian_15[x];
	}
	// color /= 15;

	gl_FragData[0] = vec4(color, 1.0);
}