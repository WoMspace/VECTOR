in vec2 uv;
in vec2 mid_uv;
in mat3 tbn;
uniform sampler2D texture;
uniform sampler2D normals;
uniform sampler2D colortex0;
uniform float alphaTestRef;
uniform mat4 gbufferModelViewInverse;

#if defined(GBUFFERS_ENTITIES) && defined(ENTITY_RADAR)
flat in int entityMask;
#endif

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec3 vertex_color;
#endif

/* RENDERTARGETS:0,3 */
void main() {
	vec3 color = texture2D(texture, mid_uv).rgb;
	vec3 normal = texture2D(normals, uv).xyz;
	float alpha = texture2D(texture, uv).a;

	normal = normal * 2.0 - 1.0;
	normal = tbn * normal;
	normal = mat3(gbufferModelViewInverse) * normal;	


	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	// color *= vertex_color;
	#endif
	if (alpha < alphaTestRef) discard;

	#ifdef GBUFFERS_SKYBASIC
	color = vec3(0.5);
	#endif

	
	
	float entity = 1.0;

	#if defined(GBUFFERS_ENTITIES) && defined(ENTITY_RADAR)
		entity = entityMask == 1 ? 0.1 : entity; // Hostile mobs
		entity = entityMask == 2 ? 0.2 : entity; // Friendly mobs
		entity = entityMask == 3 ? 0.3 : entity; // Players
	#endif

	gl_FragData[0] = vec4(color, 1.0);
	gl_FragData[1] = vec4(normal, entity);
}