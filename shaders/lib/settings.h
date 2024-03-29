uniform float viewWidth;
uniform float viewHeight;
vec2 pixelSize = 1.0 / vec2(viewWidth, viewHeight);

#define VECTOR_SHADER 0 // [0 1 2 3 4]

// #define SCANLINES
#define SCAN_SPEED 3 // [1 2 3 4 5 6 7 8 9 10]
#define SCAN_SIZE 0 // [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200]
#define GHOSTING
// #define PIXEL_SIZE 1 // [1 2 4 8 16 32 64]
// const float pixel_power = log2(PIXEL_SIZE);

#define CURVATURE_X 1.0 // [-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]
#define CURVATURE_Y 1.0 // [-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]

// #define SEE_THROUGH_GLASS

#define MONOCHROME
#define THICKER_LINES
#define LINE_COLOR_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LINE_COLOR_G 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LINE_COLOR_B 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
const vec3 USER_COLOR = vec3(LINE_COLOR_R, LINE_COLOR_G, LINE_COLOR_B);
#define BG_COLOR_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BG_COLOR_G 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BG_COLOR_B 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BG_COLOR_MUL 0.03 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
const vec3 USER_BG_COLOR = normalize(vec3(BG_COLOR_R, BG_COLOR_G, BG_COLOR_B)) * BG_COLOR_MUL;
#define LINE_THRESHOLD_CONTRAST 0.1 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LINE_THRESHOLD_DEPTH 0.01 // [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1]
#define LINE_THRESHOLD_NORMAL 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 100.0]

// #define ENTITY_RADAR
#define RADAR_FILLED
#define HOSTILE_COLOR_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define HOSTILE_COLOR_G 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define HOSTILE_COLOR_B 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
const vec3 ENTITY_COLOR_HOSTILE = vec3(HOSTILE_COLOR_R, HOSTILE_COLOR_G, HOSTILE_COLOR_B);
#define FRIENDLY_COLOR_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FRIENDLY_COLOR_G 0.4 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FRIENDLY_COLOR_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
const vec3 ENTITY_COLOR_FRIENDLY = vec3(FRIENDLY_COLOR_R, FRIENDLY_COLOR_G, FRIENDLY_COLOR_B);
#define PLAYER_COLOR_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define PLAYER_COLOR_G 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define PLAYER_COLOR_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
const vec3 ENTITY_COLOR_PLAYER = vec3(PLAYER_COLOR_R, PLAYER_COLOR_G, PLAYER_COLOR_B);

#define BLOOM_MIX 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BLOOM_SIZE 2 // [0.1 0.2 0.4 0.8 1 2 4 6 8 12 16 24 32 48 64]

// #define IS_IRIS
// #define SHOW_PLAYER_HUD
#define HUD_CROSSHAIR 0 // [0 1 2]
// #define RESEAU_PLATE
#define FIDUCIAL_MARKERS_X 3 // [1 2 3 4 5 6 7 8 9]
#define FIDUCIAL_MARKERS_Y 3 // [1 2 3 4 5 6 7 8 9]

#define RESOLUTION_WARNING 0 // [0 0 0]
// #define HUD_COMPASS_HORIZONTAL
#define HUD_COMPASS_HORIZONTAL_SPACING 16.0 // [8.0 10.0 12.0 16.0 18.0 20.0 24.0 28.0 32.0]
// #define HUD_COMPASS_VERTICAL
#define HUD_COMPASS_VERTICAL_SPACING 12.0 // [6.0 8.0 10.0 12.0 16.0 18.0 20.0 24.0 28.0 32.0]
// #define HUD_COORDS
// #define HUD_CAMERA_DETAILS


// Fix wonky option screen parsing
/*
#ifdef GHOSTING
#endif
#ifdef VECTOR_SHADER
#endif
#ifdef SEE_THROUGH_GLASS
#endif
#ifdef RESOLUTION_WARNING
#endif
*/

/* 
	COLORTEX0:
		DESC: Albedo/Main Buffer
		WRITE:
			GBUFFERS
			COMPOSITE
			COMPOSITE1
			COMPOSITE7
		READ:
			COMPOSITE
			COMPOSITE1
			COMPOSITE5
			COMPOSITE7
	COLORTEX1:
		DESC: Bloom
		WRITE:
			COMPOSITE5
			COMPOSITE6
		READ:
			COMPOSITE6
			COMPOSITE7
	COLORTEX2:
		DESC: Ghosting
		NONCLEARING: TRUE
		WRITE:
			COMPOSITE7
		READ:
			COMPOSITE7
	COLORTEX3:
		DESC: Normals, Entity mask
		WRITE:
			GBUFFERS
		READ:
			COMPOSITE
 */