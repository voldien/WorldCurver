#ifndef _GLOBAL_AXIS_CURVE_VARIABLES_CGINC
#define _GLOBAL_AXIS_CURVE_VARIABLES_CGINC 1


/*	Curve mode.	*/
#define CURVE_CLIP_SPACE 0
#define CURVE_WORLD_SPACE 1
#define CURVE_VIEW_SPACE 2

/*	Curve flags.	*/
#define CURVE_FADE 		1
#define CURVE_HORIZON 	2

CBUFFER_START(WorldCurve)
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

half4 _LengthInfluence;	/*	Allow for certain axis to be compute differently.	*/

CBUFFER_END

#endif