in vec2 vaUV0;
in vec2 mc_midTexCoord;
in vec4 at_tangent;

#if defined(GBUFFERS_ENTITIES) && defined(ENTITY_RADAR)
uniform int entityId;
flat out int entityMask;
#endif

out vec2 mid_uv;
out vec2 uv;
out mat3 tbn;

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec4 vaColor;
in vec3 vaPosition;
	#ifdef GBUFFERS_WATER
	attribute vec3 mc_Entity;
	out float blockID;
	#endif
#endif

void main() {
	gl_Position = ftransform();
	// gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
	uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	mid_uv = mc_midTexCoord - 0.01;

	vec3 normal = gl_NormalMatrix * gl_Normal;
	vec3 tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
	tbn = mat3(tangent, cross(tangent, normal) * sign(at_tangent.w), normal);

	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	vertex_color = gl_Color.rgb;
	#endif

	#ifdef GBUFFERS_WATER;
	blockID = mc_Entity.x;
	#endif


	#if defined(GBUFFERS_ENTITIES) && defined(ENTITY_RADAR)
	entityMask = entityId - 2000;
	#endif
}