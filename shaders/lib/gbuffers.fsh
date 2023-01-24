in vec2 uv;
in vec2 mid_uv;
uniform sampler2D texture;
uniform float alphaTestRef;

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec3 vertex_color;
#endif

/* RENDERTARGETS:0 */
void main() {
	vec3 color = texture2D(texture, mid_uv).rgb;
	float alpha = texture2D(texture, uv).a;


	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	// color *= vertex_color;
	#endif
	if (alpha < alphaTestRef) discard;

	#ifdef GBUFFERS_SKYBASIC
	color = vec3(0.5);
	#endif

	gl_FragData[0] = vec4(color, 1.0);
}