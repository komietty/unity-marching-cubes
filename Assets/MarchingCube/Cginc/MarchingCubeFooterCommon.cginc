#ifndef MARCHINGCUBE_FOOTER_COMMON_INCLUDED
#define MARCHINGCUBE_FOOTER_COMMON_INCLUDED

// memo
// coordinate is -0.5 ~ 0.5 in each dimention

#include "MarchingCubeHeader.cginc"

float Sample(float x, float y, float z)
{
    float3 s = _SegmentNum;
    bool f = x <= 1 || y <= 1 || z <= 1 || x >= s.x - 1 || y >= s.y - 1 || z >= s.z - 1;
    float3 p = float3(x, y, z) / s - (0.5).xxx;
    return f ? 0 : DistanceFunction(p, p * _Aspect);
}

float Sample(float3 p) { return Sample(p.x, p.y, p.z); } 

float getOffset(float val1, float val2)
{
    // when drawn, one have to be greater than threshold, other have to be smaller than threshold
    // suppose (val1 = th + a, val2 = th - b), or (val1 = th - a, val2 = th - b) under 0 < a, b
    // the returned value is always a / (a + b) which represents linear interpolation
	float delta = val2 - val1;
    return delta == 0 ? 0.5 : (_Threashold - val1) / delta;
}

float3 getNormal(float fX, float fY, float fZ)
{
	float3 normal;
	float offset = 1.0;
	normal.x = Sample(fX - offset, fY, fZ) - Sample(fX + offset, fY, fZ);
	normal.y = Sample(fX, fY - offset, fZ) - Sample(fX, fY + offset, fZ);
	normal.z = Sample(fX, fY, fZ - offset) - Sample(fX, fY, fZ + offset);
	return normal;
}


float3 getNormal(float3 f) { return getNormal(f.x, f.y, f.z); }

float2 barycentricCoordinateArr(uint i) { return float2((i == 0) ? 1 : 0, (i == 1) ? 1 : 0); }

v2g vert(appdata v)
{
    v2g o = (v2g) 0;
	o.pos = v.vertex;
	return o;
}
#endif