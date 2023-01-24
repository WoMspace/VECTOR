in vec2 uv;
uniform sampler2D texture;
uniform float alphaTestRef;

#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
in vec4 vcolor;
#endif

/* RENDERTARGETS:0 */
void main() {
	vec4 color = texture2D(texture, uv);


	#if defined(GBUFFERS_TERRAIN) || defined(GBUFFERS_WATER)
	// color *= vcolor;
	#endif
	if (color.a < alphaTestRef) discard;

	gl_FragData[0] = color;
}