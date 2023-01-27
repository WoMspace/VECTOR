uniform float viewWidth;
uniform float viewHeight;
vec2 pixelSize = 1.0 / vec2(viewWidth, viewHeight);

#define VECTOR_SHADER 0 // [0 1 2 3 4]

// #define SCANLINES
#define GHOSTING
// #define PIXEL_SIZE 1 // [1 2 4 8 16 32 64]
// const float pixel_power = log2(PIXEL_SIZE);

#define CURVATURE_X 1.0 // [-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]
#define CURVATURE_Y 1.0 // [-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]

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
#define LINE_THRESHOLD_CONTRAST 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LINE_THRESHOLD_DEPTH 0.01 // [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1]
#define LINE_THRESHOLD_NORMAL 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 100.0]

#define BLOOM_MIX 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BLOOM_SIZE 2 // [0.1 0.2 0.4 0.8 1 2 4 6 8 12 16 24 32 48 64]

// Fix wonky option screen parsing
#ifdef GHOSTING
#endif
// #ifdef VECTOR_SHADER
// #endif