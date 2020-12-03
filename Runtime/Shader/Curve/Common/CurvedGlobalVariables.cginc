#ifndef _GLOBAL_AXIS_CURVE_VARIABLES_
#define _GLOBAL_AXIS_CURVE_VARIABLES_ 1

/*	Global curve pragma.	*/
#pragma multi_compile CURVED_ON CURVED_OFF
/*	Local outline pragmas.	*/
#pragma multi_compile_local OUTLINE_TRIANGLE OUTLINE_REGULAR OUTLINE_CUSTOM
//#pragma multi_compile _ CURVED_ON

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