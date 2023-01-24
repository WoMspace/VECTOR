in vec2 vaUV0;
in vec2 mc_midTexCoord;

out vec2 mid_uv;
out vec2 uv;

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec4 vaColor;
in vec3 vaPosition;
out vec3 vertex_color;
#endif

void main() {
	gl_Position = ftransform();
	uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	mid_uv = mc_midTexCoord;
	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	vertex_color = vaColor.rgb;
	#endif
}