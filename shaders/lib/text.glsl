/*
--------------------------------------------------------------------------------

  GLSL Debug Text Renderer by SixthSurge

  Character set based on Monocraft by IdreesInc
  https://github.com/IdreesInc/Monocraft

  Usage:

  // Call beginText to initialize the text renderer. You can scale the fragment position to adjust the size of the text
  beginText(ivec2(gl_FragCoord.xy), ivec2(0, viewHeight));
            ^ fragment position     ^ text box position (upper left corner)

  // You can print various data types
  printBool(false);
  printFloat(sqrt(-1.0)); // Prints "NaN"
  printInt(42);
  printVec3(skyColor);

  // ...or arbitrarily long strings
  printString((_H, _e, _l, _l, _o, _comma, _space, _w, _o, _r, _l, _d));

  // To start a new line, use
  newLine();

  // You can also configure the text color on the fly
  text.fgCol = vec4(1.0, 0.0, 0.0, 1.0);
  text.bgCol = vec4(0.0, 0.0, 0.0, 1.0);

  // ...as well as the number base and number of decimal places to print
  text.base = 16;
  text.fpPrecision = 4;

  // Finally, call endText to blend the current fragment color with the text
  endText(fragColor);

  Important: any variables you display must be the same for all fragments, or
  at least all of the fragments that the text covers. Otherwise, different
  fragments will try to print different values, resulting in, well, a mess

--------------------------------------------------------------------------------
*/

#if !defined UTILITY_TEXTRENDERING_INCLUDED
#define UTILITY_TEXTRENDERING_INCLUDED

// Include a font here
#include "/lib/terminus.glsl"

const int charWidth   = 8;
const int charHeight  = 16;
const int charSpacing = 1;
const int lineSpacing = 3;

const ivec2 charSize  = ivec2(charWidth, charHeight);
const ivec2 spaceSize = charSize + ivec2(charSpacing, lineSpacing);

// Text renderer

struct Text {
	vec4 result;     // Output color from the text renderer
	vec4 fgCol;      // Text foreground color
	vec4 bgCol;      // Text background color
	ivec2 fragPos;   // The position of the fragment (can be scaled to adjust the size of the text)
	ivec2 textPos;   // The position of the top-left corner of the text
	ivec2 charPos;   // The position of the next character in the text
	int base;        // Number base
	int fpPrecision; // Number of decimal places to print
} text;

// Fills the global text object with default values
void beginText(ivec2 fragPos, ivec2 textPos) {
	text.result      = vec4(0.0);
	text.fgCol       = vec4(1.0);
	text.bgCol       = vec4(0.0, 0.0, 0.0, 0.6);
	text.fragPos     = fragPos;
	text.textPos     = textPos;
	text.charPos     = ivec2(0);
	text.base        = 10;
	text.fpPrecision = 2;
}

// Applies the rendered text to the fragment
void endText(inout vec3 fragColor) {
	fragColor = mix(fragColor.rgb, text.result.rgb, text.result.a);
}

void printChar(uvec4 character) {
	ivec2 pos = text.fragPos - text.textPos - spaceSize * text.charPos * ivec2(1, -1) + ivec2(0, spaceSize.y);

	uint index = uint(pos.y * 8 + 7 - pos.x);

	// Draw background
	if (clamp(pos, ivec2(0), spaceSize - 1) == pos)
		text.result = mix(text.result, text.bgCol, text.bgCol.a);

	// Draw character
	if (clamp(pos, ivec2(0), charSize - 1) == pos)
		text.result = mix(text.result, text.fgCol, text.fgCol.a * float((character[(index >> 5)] >> (index & 31u)) & 1u));

	// Advance to next character
	text.charPos.x++;
}

#define printString(string) {                                               \
	uvec4[] characters = uvec4[] string;                                     \
	for (int i = 0; i < characters.length(); ++i) printChar(characters[i]); \
}

void printUnsignedInt(uint value, int len) {
	const uvec4[36] digits = uvec4[](
		_0, _1, _2, _3, _4, _5, _6, _7, _8, _9,
		_a, _b, _c, _d, _e, _f, _g, _h, _i, _j,
		_k, _l, _m, _n, _o, _p, _q, _r, _s, _t,
		_u, _v, _w, _x, _y, _z
	);

	// Advance to end of the number
	text.charPos.x += len - 1;

	// Write number backwards
	for (int i = 0; i < len; ++i) {
		printChar(digits[value % uint(text.base)]);
		value /= uint(text.base);
		text.charPos.x -= 2;
	}

	// Return to end of the number
	text.charPos.x += len + 1;
}

void printUnsignedInt(uint value) {
	float logValue = log(float(value)) + 1e-6;
	float logBase  = log(float(text.base));

	int len = int(ceil(logValue / logBase));
	    len = max(len, 1);

	printUnsignedInt(value, len);
}

void printInt(int value) {
	if (value < 0) printChar(_hyphn);
	printUnsignedInt(uint(abs(value)));
}

void printFloat(float value) {
	if (value < 0.0) printChar(_hyphn);

	if (isnan(value)) {
		printString((_N, _a, _N));
	} else if (isinf(value)) {
		printString((_i, _n, _f));
	} else {
		float i, f = modf(abs(value), i);

		uint integralPart   = uint(i);
		uint fractionalPart = uint(f * pow(float(text.base), float(text.fpPrecision)) + 0.5);

		printUnsignedInt(integralPart);
		printChar(_dot);
		printUnsignedInt(fractionalPart, text.fpPrecision);
	}
}

void printBool(bool value) {
	if (value) {
		printString((_t, _r, _u, _e));
	} else {
		printString((_f, _a, _l, _s, _e));
	}
}

void printVec2(vec2 value) {
	printFloat(value.x);
	printString((_comma, _space));
	printFloat(value.y);
}
void printVec3(vec3 value) {
	printFloat(value.x);
	printString((_comma, _space));
	printFloat(value.y);
	printString((_comma, _space));
	printFloat(value.z);
}
void printVec4(vec4 value) {
	printFloat(value.x);
	printString((_comma, _space));
	printFloat(value.y);
	printString((_comma, _space));
	printFloat(value.z);
	printString((_comma, _space));
	printFloat(value.w);
}

void printIvec2(ivec2 value) {
	printInt(value.x);
	printString((_comma, _space));
	printInt(value.y);
}
void printIvec3(ivec3 value) {
	printInt(value.x);
	printString((_comma, _space));
	printInt(value.y);
	printString((_comma, _space));
	printInt(value.z);
}
void printIvec4(ivec4 value) {
	printInt(value.x);
	printString((_comma, _space));
	printInt(value.y);
	printString((_comma, _space));
	printInt(value.z);
	printString((_comma, _space));
	printInt(value.w);
}

void printUvec2(uvec2 value) {
	printUnsignedInt(value.x);
	printString((_comma, _space));
	printUnsignedInt(value.y);
}
void printUvec3(uvec3 value) {
	printUnsignedInt(value.x);
	printString((_comma, _space));
	printUnsignedInt(value.y);
	printString((_comma, _space));
	printUnsignedInt(value.z);
}
void printUvec4(uvec4 value) {
	printUnsignedInt(value.x);
	printString((_comma, _space));
	printUnsignedInt(value.y);
	printString((_comma, _space));
	printUnsignedInt(value.z);
	printString((_comma, _space));
	printUnsignedInt(value.w);
}

void printLine() {
	text.charPos.x = 0;
	++text.charPos.y;
}

#endif // UTILITY_TEXTRENDERING_INCLUDED
