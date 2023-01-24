#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
in vec2 uv;

/* RENDERTARGETS:0 */
void main() {

	vec3 color = texture2D(colortex0, uv).rgb;
	vec3 bloom = texture2D(colortex1, uv).rgb;

	color = color + mix(color, bloom, BLOOM_MIX);
	color = clamp(color, 0.0, 1.0);

	gl_FragData[0] = vec4(color, 1.0);
}