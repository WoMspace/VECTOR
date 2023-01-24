in vec2 vaUV0;

out vec2 uv;

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec4 vaColor;
in vec3 vaPosition;
out vec4 vcolor;
#endif

void main() {
	gl_Position = ftransform();
	uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	vcolor = vaColor;
	#endif
}