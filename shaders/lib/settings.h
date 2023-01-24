uniform float viewWidth;
uniform float viewHeight;
vec2 pixelSize = 1.0 / vec2(viewWidth, viewHeight);

#define MONOCHROME
#define PIXEL_SIZE 1 // [1 2 4 8 16 32 64]

#define LINE_COLOR_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LINE_COLOR_G 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LINE_COLOR_B 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LINE_THRESHOLD 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define BLOOM_MIX 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define BLOOM_SIZE 1 // [0.1 0.2 0.4 0.8 1 2 4 6 8 12 16 24 32 48 64]