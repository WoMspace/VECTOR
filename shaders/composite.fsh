#version 150 compatibility

#include "/lib/settings.h"
#include "/lib/iris.glsl"

uniform sampler2D colortex0; // albedo
uniform sampler2D colortex3; // normals, entity mask
uniform sampler2D depthtex0;
in vec2 uv;


#if defined(SHOW_PLAYER_HUD) && defined(IS_IRIS)
uniform float currentPlayerHealth;
uniform float maxPlayerHealth;
uniform float currentPlayerAir;
uniform float maxPlayerAir;
uniform float currentPlayerHunger;
uniform float maxPlayerHunger;
#endif

uniform float frameTimeCounter;
uniform int hideGUI;
uniform float far;
uniform float near;

const float edge_kernel[9] = float[](-1.0, -1.0, -1.0, -1.0, 8.0, -1.0, -1.0, -1.0, -1.0);

// Choc version
float linearizeDepth(float dist) {
    return (2.0 * near) / (far + near - dist * (far - near));
}

bool equals(float input1, float input2, float epsilon) {
	return abs(input1 - input2) < epsilon;
}

/* RENDERTARGETS:0 */
void main() {

	vec3 color = vec3(0.0);


	#ifdef IS_IRIS
		#ifdef SHOW_PLAYER_HUD
		
		// HP bar
		if(uv.x > 0.275 && uv.x < 0.475 - (0.2 - currentPlayerHealth * 0.2) && uv.y > 0.125 && uv.y < 0.15 && currentPlayerHealth > 0.0) {
			color = vec3(1.0, 0.0, 0.0);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		} else if(currentPlayerHealth > -1.0 && uv.x > 0.275 && uv.x < 0.475 && uv.y > 0.1225 && uv.y < 0.125) {
			color = vec3(1.0, 0.0, 0.0);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		}
		// Hunger bar
		else if(uv.x > 0.525 + (0.2 - currentPlayerHunger * 0.2) && uv.x < 0.725 && uv.y > 0.125 && uv.y < 0.15) {
			color = vec3(1.0, 1.0, 0.0);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		} else if(currentPlayerHunger > -1.0 && uv.x > 0.525 && uv.x < 0.725 && uv.y > 0.1225 && uv.y < 0.125) {
			color = vec3(1.0, 1.0, 0.0);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		}
		// Air bar
		else if(currentPlayerAir < 1.0 && uv.x > 0.275 + (0.225 - currentPlayerAir * 0.225) && uv.x < 0.725 - (0.225 - currentPlayerAir * 0.225) && uv.y > 0.175 && uv.y < 0.2) {
			color = vec3(0.0, 0.5, 1.0);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		}
		else if(currentPlayerAir > -1.0 && currentPlayerAir < 1.0 && uv.x > 0.275 && uv.x < 0.725 && uv.y > 0.1725 && uv.y < 0.175) {
			color = vec3(0.0, 0.5, 1.0);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		}
		#if HUD_CROSSHAIR == 1
		// Cross crosshair
		ivec2 screenCenter = ivec2(viewWidth, viewHeight) / 2;
		if((abs(gl_FragCoord.x - screenCenter.x) < 10 && abs(gl_FragCoord.y - screenCenter.y) < 1)
		|| (abs(gl_FragCoord.y - screenCenter.y) < 10 && abs(gl_FragCoord.x - screenCenter.x) < 1)) {
			color = vec3(USER_COLOR);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		}
		#elif HUD_CROSSHAIR == 2
		// Circle crosshair
		ivec2 screenCenter = ivec2(viewWidth, viewHeight) / 2;
		float dist = distance(screenCenter, gl_FragCoord.xy);
		if(dist < 10 && dist > 9  || dist < 1) {
			color = vec3(USER_COLOR);
			gl_FragData[0] = vec4(color, 1.0);
			return;
		}
		#endif
		#endif
	#elif defined(SHOW_PLAYER_HUD)
	if(hideGUI == 0){
		showWarning(color, frameTimeCounter);
		gl_FragData[0] = vec4(color, 1.0);
		return;
	}
	#endif
	
	for(int y = 0; y < 3; y++) {
		for(int x = 0; x < 3; x++) {
			vec2 offset = pixelSize * vec2(x - 1, y - 1) * 1.0;
			color += texture2D(colortex0, uv + offset).rgb * edge_kernel[y * 3 + x];
		}
	}
	color /= 4.5;

	float depth = 0.0;
	for(int y = 0; y < 3; y++) {
		for(int x = 0; x < 3; x++) {
			vec2 offset = pixelSize * vec2(float(x) - 1.0, float(y) - 1.0) * 1.0;
			float rawDepth = texture2D(depthtex0, uv + offset).r;
			depth += linearizeDepth(rawDepth) * edge_kernel[y * 3 + x];
		}
	}
	depth *= 0.8;

	vec3 normal = vec3(0.0);
	for(int y = 0; y < 3; y++) {
		for(int x = 0; x < 3; x++) {
			vec2 offset = pixelSize * vec2(x - 1, y - 1) * 1.0;
			normal += texture2D(colortex3, uv + offset).rgb * edge_kernel[y * 3 + x];
		}
	}

	// Human eye sensitivity
	float grey = dot(color, vec3(0.21, 0.72, 0.07));
	float normalGrey = dot(abs(normal), vec3(1.0));

	float sobelLine = grey > LINE_THRESHOLD_CONTRAST ? 1.0 : 0.0;
	float depthLine = depth > LINE_THRESHOLD_DEPTH ? 1.0 : 0.0;
	float normalLine = normalGrey > LINE_THRESHOLD_NORMAL ? 1.0 : 0.0;
	float line = max(depthLine, sobelLine);
	line = max(line, normalLine);

	#ifdef MONOCHROME
	color = normalize(USER_COLOR) * line;
	#else
	color = normalize(color) * line;
	#endif

	#ifdef ENTITY_RADAR
		float entityMask = texture2D(colortex3, uv).a;

		#ifdef RADAR_FILLED
		bool doRadarColor = entityMask > 0.01;
		#else
		bool doRadarColor = line > 0.01;
		#endif
		
		if(doRadarColor) {
			color = equals(entityMask, 0.1, 0.01) ? ENTITY_COLOR_HOSTILE : color;
			color = equals(entityMask, 0.2, 0.01) ? ENTITY_COLOR_FRIENDLY : color;
			color = equals(entityMask, 0.3, 0.01) ? ENTITY_COLOR_PLAYER : color;
		}
	#endif

	gl_FragData[0] = vec4(color, 1.0);
}