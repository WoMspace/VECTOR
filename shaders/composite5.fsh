#version 150 compatibility

#include "/lib/settings.h"

uniform sampler2D colortex0;
in vec2 uv;

#include "/lib/blur.h"

/* RENDERTARGETS:1 */
void main() {

	vec3 color = gaussianHorizontal(colortex0, uv);

	gl_FragData[0] = vec4(color, 1.0);
}