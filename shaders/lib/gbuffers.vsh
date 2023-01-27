in vec2 vaUV0;
in vec2 mc_midTexCoord;
in vec4 at_tangent;

out vec2 mid_uv;
out vec2 uv;
out mat3 tbn;
// out vec3 normal;

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec4 vaColor;
in vec3 vaPosition;
out vec3 vertex_color;
#endif

void main() {
	gl_Position = ftransform();
	uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	mid_uv = mc_midTexCoord - 0.01;

	vec3 normal = gl_NormalMatrix * gl_Normal;
	vec3 tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
	tbn = mat3(tangent, cross(tangent, normal) * sign(at_tangent.w), normal);

	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	vertex_color = vaColor.rgb;
	#endif
}