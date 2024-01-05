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

#if defined HUD_COMPASS_HORIZONTAL || defined HUD_COMPASS_VERTICAL
uniform mat4 gbufferModelView;
#endif

#ifdef HUD_COORDS
uniform vec3 cameraPosition;
#endif
#ifdef HUD_CAMERA_DETAILS
uniform mat4 gbufferProjection;
#endif

uniform float frameTimeCounter;
uniform int hideGUI;
uniform float far;
uniform float near;
uniform float aspectRatio;

const float edge_kernel[9] = float[](-1.0, -1.0, -1.0, -1.0, 8.0, -1.0, -1.0, -1.0, -1.0);

// Choc version
float linearizeDepth(float dist) {
    return (2.0 * near) / (far + near - dist * (far - near));
}

bool equals(float input1, float input2, float epsilon) {
	return abs(input1 - input2) < epsilon;
}

bool isCross(ivec2 position, int crossLength, int crossGirth) {
	return (abs(gl_FragCoord.x - position.x) < crossLength && abs(gl_FragCoord.y - position.y) < crossGirth)
	|| (abs(gl_FragCoord.y - position.y) < crossLength && abs(gl_FragCoord.x - position.x) < crossGirth);
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
				if(isCross(screenCenter, 10, 1)) {
					gl_FragData[0] = vec4(USER_COLOR, 1.0);
					return;
				}
			#elif HUD_CROSSHAIR == 2
				// Circle crosshair
				ivec2 screenCenter = ivec2(viewWidth, viewHeight) / 2;
				float dist = distance(screenCenter, gl_FragCoord.xy);
				if(dist < 10 && dist > 9  || dist < 1) {
					gl_FragData[0] = vec4(USER_COLOR, 1.0);
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

	#ifdef RESEAU_PLATE
		for(int x = 0; x < FIDUCIAL_MARKERS_X; x++) { for(int y = 0; y < FIDUCIAL_MARKERS_Y; y++) {
			ivec2 marker_position = ivec2(
				viewWidth / FIDUCIAL_MARKERS_X * (x + 0.5),
				viewHeight / FIDUCIAL_MARKERS_Y * (y + 0.5)
			);

			if(isCross(marker_position, 20, 1)) {
				gl_FragData[0] = vec4(USER_COLOR, 1.0);
				return;
			};
		}}
	#endif

	#ifdef HUD_COORDS
	{
		ivec3 coords = ivec3(cameraPosition);
		// box
		if(uv.x > 0.01 && uv.x < 0.08 && uv.y > 0.85 && uv.y < 0.97) {
			if(uv.x > 0.011 && uv.x < 0.079 && uv.y > 0.8515 && uv.y < 0.9685) {
				vec3 col = vec3(0.0);
				beginText(ivec2(gl_FragCoord.xy * 0.5), ivec2(vec2(0.025 * viewWidth, 0.97 * viewHeight) * 0.5));
				text.fgCol = vec4(USER_COLOR, 1.0);
				// right-align
				if(abs(coords.x) < 1000) {printString((_space));}; if(abs(coords.x) < 100) {printString((_space));}; if(abs(coords.x) < 10) {printString((_space));}; if(coords.x >= 0) printString((_space));
				// x-component
				printInt(coords.x); printLine();
				// right-align
				if(abs(coords.y) < 1000) {printString((_space));}; if(abs(coords.y) < 100) {printString((_space));}; if(abs(coords.y) < 10) {printString((_space));}; if(coords.y >= 0) printString((_space));
				// y-component
				printInt(coords.y); printLine();
				// right-align
				if(abs(coords.z) < 1000) {printString((_space));}; if(abs(coords.z) < 100) {printString((_space));}; if(abs(coords.z) < 10) {printString((_space));}; if(coords.z >= 0) printString((_space));
				// z-component
				printInt(coords.z);
				endText(col);
				gl_FragData[0] = vec4(col, 1.0);
				return;
			} else {

				gl_FragData[0] = vec4(USER_COLOR, 1.0);
				return;
			}
		}
	}
	#endif

	#ifdef HUD_CAMERA_DETAILS
	{
		if(uv.x > 0.01 && uv.x < 0.15 && uv.y > 0.04 && uv.y < 0.125) {
			if(uv.x > 0.011 && uv.x < 0.149 && uv.y > 0.0415 && uv.y < 0.1235) {
				vec3 col = vec3(0.0);
				beginText(ivec2(gl_FragCoord.xy * 0.5), ivec2(0.015 * viewWidth, 0.125 * viewHeight) / 2);
				text.fgCol = vec4(USER_COLOR, 1.0);
				float focal_length = gbufferProjection[1].y * 11.87;
				float fov = 2.0 * atan(24.0 / (2.0 * focal_length));
				fov = degrees(fov);
				// right-align
				// if(fov < 100.0) {printChar(_space);}; if(fov < 10.0) { printChar(_space);};
				printUnsignedInt(uint(fov)); printChar(_deg);
				printLine();
				printUnsignedInt(uint(viewWidth)); printChar(_times); printUnsignedInt(uint(viewHeight));
				endText(col);
				gl_FragData[0] = vec4(col, 1.0);
				return;
			} else {
				gl_FragData[0] = vec4(USER_COLOR, 1.0);
				return;
			}
		}
	}
	#endif

	#ifdef HUD_COMPASS_HORIZONTAL
	{
		float size = HUD_COMPASS_HORIZONTAL_SPACING;
		float theta = gbufferModelView[0][0];
		theta = acos(theta) / 3.1415926;
		if(gbufferModelView[2][0] < 0.0) theta *= -1.0;
		theta *= 180.0;

		// calibration line
		if(abs(uv.x - 0.5) < 0.0005 && uv.y > 0.915 && uv.y < 0.955) {
			gl_FragData[0] = vec4(USER_COLOR, 1.0);
			return;
		}

		// lines
		if(uv.x > 0.3 && uv.x < 0.7 && uv.y > 0.92 && uv.y < 0.95) {
			for(int angle_marker = 0; angle_marker < 720; angle_marker += 5) {
				float offset = -theta * size + viewWidth * 0.5;
				if(theta < 180.0) { offset -= 360.0 * size; }
				float line_pos = angle_marker * size + offset;
				if(abs(gl_FragCoord.x - line_pos) < 1.0) {
					gl_FragData[0] = vec4(USER_COLOR, 1.0);
					return;
				}
			}
			gl_FragData[0] = vec4(0.0);
			return;
		}
		// text
		if(uv.x > 0.3 && uv.x < 0.7 && uv.y > 0.95 && uv.y < 0.99) {
			beginText(ivec2(gl_FragCoord.xy * 0.5), ivec2(0));
			text.fgCol = vec4(USER_COLOR, 1.0);
			text.bgCol = vec4(0.0);
			vec3 text_line = vec3(0.0);
			
			for(int angle_marker = 0; angle_marker < 720; angle_marker += 10) {
				float offset = -theta * size + viewWidth * 0.5;
				float digit_offset = 6.0;
				if(angle_marker % 360 >= 10.0) digit_offset += 10.0;
				if(angle_marker % 360 >= 100.0) digit_offset += 8.0;
				if(theta < 180.0) { offset -= 360.0 * size; }
				vec2 text_pos = vec2(angle_marker * size + offset - digit_offset, viewHeight * 0.993) * 0.5;
				text.charPos = ivec2(0);
				text.textPos = ivec2(text_pos);
				printInt(angle_marker % 360);
				// printLine();
				// printChar(_pipe);
			}

			endText(text_line);
			gl_FragData[0] = vec4(text_line, 1.0);
			return;
		}
	}
	#endif
	#ifdef HUD_COMPASS_VERTICAL
	{
		const float size = HUD_COMPASS_VERTICAL_SPACING;
		float theta = gbufferModelView[1][2];
		theta = acos(theta) / 3.1415926;
		theta = theta * 180.0 - 90.0;

		// calibration line
		if(uv.x > 0.045 && uv.x < 0.075 && abs(uv.y - 0.5) < 0.001) {
			gl_FragData[0] = vec4(USER_COLOR, 1.0);
			return;
		}
		// lines
		if(uv.x > 0.05 && uv.x < 0.07 && uv.y > 0.2 && uv.y < 0.8) {
			for(int angle_marker = -130; angle_marker <= 130; angle_marker += 5) {
				float offset = -theta * size + viewHeight * 0.5;
				float line_pos = angle_marker * size + offset;
				if(abs(gl_FragCoord.y - line_pos) < 1.0) {
					gl_FragData[0] = vec4(USER_COLOR, 1.0);
					return;
				}
			}
			gl_FragData[0] = vec4(0.0);
			return;
		}

		// text
		if(uv.x > 0.01 && uv.x < 0.05 && uv.y > 0.2 && uv.y < 0.8) {
			beginText(ivec2(gl_FragCoord.xy * 0.5), ivec2(0));
			text.fgCol = vec4(USER_COLOR, 1.0);
			text.bgCol = vec4(0.0);
			vec3 text_line = vec3(0.0);

			for(int angle_marker = -130; angle_marker <= 130; angle_marker += 10) {
				float offset = -theta * size + viewHeight * 0.5;
				vec2 digit_offset = vec2(0.0, 10.0);
				if(angle_marker < 0.0) digit_offset.x -= 9.0;
				if(abs(angle_marker) >= 10.0) digit_offset.x -= 9.0;
				if(abs(angle_marker) >= 100.0) digit_offset.x -= 9.0;
				vec2 text_pos = vec2(viewWidth * 0.035, angle_marker * size + offset) * 0.5 + digit_offset;
				text.charPos = ivec2(0);
				text.textPos = ivec2(text_pos);
				printInt(angle_marker);
			}

			endText(text_line);
			gl_FragData[0] = vec4(text_line, 1.0);
			return;
		}
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