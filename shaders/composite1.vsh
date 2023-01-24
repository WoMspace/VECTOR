#version 150 compatibility

#include "/lib/settings.h"

in vec2 vaUV0;

out vec2 uv;

void main() {
	gl_Position = ftransform();
	uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}