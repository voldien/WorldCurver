#ifndef _GLOBAL_AXIS_CURVE_VARIABLES_
#define _GLOBAL_AXIS_CURVE_VARIABLES_ 1

/*	Curve mode.	*/
#define CURVE_CLIP_SPACE 0
#define CURVE_WORLD_SPACE 1
#define CURVE_VIEW_SPACE 2

/*	Curve flags.	*/
#define CURVE_FADE 		1
#define CURVE_HORIZON 	2

/*	*/
int _CurveMode;
/*	*/
int _CurveFlags;
/*	*/
half _CurveStrength;
/*	*/
float _Horizon;
/*	*/
float _FadeDist;
/*	*/
float4 _Direction;

#endif