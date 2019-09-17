#ifndef MARCHINGCUBE_HEADER_INCLUDED
#define MARCHINGCUBE_HEADER_INCLUDED

#include "UnityPBSLighting.cginc"
#include "Lighting.cginc"

#define ZERO_ARRAY { (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx, (0).xxx };
		
struct appdata
{
	float4 vertex : POSITION;
};
struct v2g
{
	float4 pos : SV_POSITION;
};
struct g2f_wire
{
	float4 pos : SV_POSITION;
	float3 normal : NORMAL;
	float4 worldPos	: TEXCOORD0;
	half3 sh : TEXCOORD1;
	float2 barycentricCoordinates : TEXCOORD2;
};

struct g2f_light
{
    float4 pos : SV_POSITION;
    float3 normal : NORMAL;
    float4 worldPos : TEXCOORD3;
    half3 sh : TEXCOORD4;
};
		
struct g2f_shadow
{
    float4 pos : SV_POSITION;
    float4 hpos : TEXCOORD5;
};

float3 _SegmentNum;
float3 _Scale;
float3 _Aspect;
float _Threashold;
float4 _DiffuseColor;
float4x4 _Matrix;
float _EmissionIntensity;
half3 _EmissionColor;
half _Glossiness;
half _Metallic;
float3 _WireframeColor;
float _WireframeSmoothing;
float _WireframeThickness;
float _LerpVal;

StructuredBuffer<float3> vertexOffset;
StructuredBuffer<int> cubeEdgeFlags;
StructuredBuffer<int2> edgeConnection;
StructuredBuffer<float3> edgeDirection;
StructuredBuffer<int> triangleConnectionTable;

#endif
