in vec2 vaUV0;
in vec2 mc_midTexCoord;

out vec2 mid_uv;
out vec2 uv;

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec4 vaColor;
in vec3 vaPosition;
out vec4 vcolor;
#endif

void main() {
	gl_Position = ftransform();
	uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	mid_uv = mc_midTexCoord;
	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	vcolor = vaColor;
	#endif
}