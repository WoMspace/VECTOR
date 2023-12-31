#include "/lib/text.glsl"

void showWarning(inout vec3 color, float frameTimeCounter) {

	const float fontSize = 0.6; // smaller number = bigger text
	beginText(ivec2(gl_FragCoord.xy * fontSize), ivec2(20, viewHeight * fontSize - 30));
	text.fgCol = vec4(USER_COLOR, 1.0);
	text.bgCol = vec4(vec3(0.0), 1.0);
	// VECTOR ©️ Imperion Inc. 2023
	printString((_V, _E, _C, _T, _O, _R, _space, _opprn, _C, _clprn, _space, _I, _m, _p, _e, _r, _i, _o, _n, _space, _I, _n, _c, _dot, _space, _2, _0, _2, _3));
	printLine();
	printLine();
	// setting "PLAYER HUD" requires IRIS 1.6 or later!
	printString((_s, _e, _t, _t, _i, _n, _g, _space, _quote, _P, _L, _A, _Y, _E, _R, _space, _H, _U, _D, _quote));
	printString((_space, _r, _e, _q, _u, _i, _r, _e, _s, _space, _I, _R, _I, _S, _space, _1, _dot, _6, _space, _o, _r, _space, _l, _a, _t, _e, _r, _exclm));
	printLine();

	// see "irisshaders.net" to download
	printString((_s, _e, _e, _space, _quote, _i, _r, _i, _s, _s, _h, _a, _d, _e, _r, _s, _dot, _n, _e, _t, _quote, _space, _t, _o, _space, _d, _o, _w, _n, _l, _o, _a, _d));
	printLine();
	// workaround for OPTIFINE:
	printString((_w, _o, _r, _k, _a, _r, _o, _u, _n, _d, _space, _f, _o, _r, _space, _O, _P, _T, _I, _F, _I, _N, _E, _colon));
	printLine();
	//   set [SCREEN] > "PLAYER HUD" to OFF
	printString((_space, _space, _s, _e, _t, _space, _opsqr, _S, _C, _R, _E, _E, _N, _clsqr, _space, _gt, _space, _quote, _P, _L, _A, _Y, _E, _R, _space, _H, _U, _D, _quote, _space, _t, _o, _space, _O, _F, _F));
	printLine();

	// workaround for IRIS 1.5:
	printString((_w, _o, _r, _k, _a, _r, _o, _u, _n, _d, _space, _f, _o, _r, _space, _I, _R, _I, _S, _space, _1, _dot, _5, _colon));
	printLine();
	//   set [DEBUG] > "IS_IRIS" to ON
	printString((_space, _space, _s, _e, _t, _space, _opsqr, _D, _E, _B, _U, _G, _clsqr, _space, _gt, _space, _quote, _I, _S, _under, _I, _R, _I, _S, _quote, _space, _t, _o, _space, _O, _N));

	//F1 to temporarily hide this message...
	printLine();
	printLine();
	printString((_F, _1, _space, _t, _o, _space, _t, _e, _m, _p, _o, _r, _a, _r, _i, _l, _y, _space, _h, _i, _d, _e, _space, _t, _h, _i, _s, _space, _m, _e, _s, _s, _a, _g, _e, _dot, _dot, _dot));
	
	// cursor console
	printLine();
	printString((_gt));
	float frx = fract(frameTimeCounter);
	if(frx < 0.5) {
		printString((_block));
	}

	endText(color);
}