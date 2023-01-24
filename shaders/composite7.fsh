#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
const bool colortex2Clear = false;
// const int colortex2Format = RGBA16F;
uniform float frameTime;
in vec2 uv;

/* RENDERTARGETS:0,2 */
void main() {

	vec3 color = texture2D(colortex0, uv).rgb;
	vec3 bloom = texture2D(colortex1, uv).rgb;

	color = color + mix(color, bloom, BLOOM_MIX);
	color = clamp(color, 0.0, 1.0);

	vec3 prevFrame = texture2D(colortex2, uv).rgb;
	prevFrame = mix(color, prevFrame, exp2(-46.0 * frameTime));
	color = mix(color, prevFrame, 0.1);

	gl_FragData[0] = vec4(color, 1.0);
	gl_FragData[0] = vec4(prevFrame, 1.0);
}