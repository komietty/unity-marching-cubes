#ifndef MARCHINGCUBE_FOOTER_WIREFRAME_INCLUDED
#define MARCHINGCUBE_FOOTER_WIREFRAME_INCLUDED

#include "MarchingCubeHeader.cginc"
#include "MarchingCubeFooterCommon.cginc"

[maxvertexcount(15)]
void geom_wire(point v2g input[1], inout TriangleStream<g2f_wire> outStream)
{
    g2f_wire o = (g2f_wire) 0;
	int i, j;
	float1 cubeValue[8];
    float3 edgeVrts[12] = ZERO_ARRAY;
    float3 edgeNrms[12] = ZERO_ARRAY;
	float3 pos = input[0].pos.xyz;
	float3 defpos = pos;

    for (i = 0; i < 8; i++)
        cubeValue[i] = Sample(pos + vertexOffset[i]);

	pos = pos * _Scale - 0.5;

	int flagIndex = 0;
    for (i = 0; i < 8; i++)
        if (cubeValue[i] <= _Threashold) flagIndex |= (1 << i);

	int edgeFlags = cubeEdgeFlags[flagIndex];
	if (edgeFlags == 0 || edgeFlags == 255) return;

	for (i = 0; i < 12; i++) {
		if ((edgeFlags & (1 << i)) != 0) {
            int2 ec = edgeConnection[i];
			float1 offset = getOffset(cubeValue[ec.x], cubeValue[ec.y]);
			float3 vertex = vertexOffset[ec.x] + offset * edgeDirection[i];
			edgeVrts[i] = pos + vertex * _Scale;
			edgeNrms[i] = getNormal(defpos + vertex);
		}
	}
            
	for (i = 0; i < 5; i++) {
		int fid = flagIndex * 16 + 3 * i;
		if (triangleConnectionTable[fid] < 0) break;
		for (j = 0; j < 3; j++) {
			int vid = triangleConnectionTable[fid + j];
			float4 _pos = mul(_Matrix, float4(edgeVrts[vid], 1));
			float3 _nrm = UnityObjectToWorldNormal(normalize(edgeNrms[vid]));
			o.pos = UnityObjectToClipPos(_pos);
            o.worldPos = mul(unity_ObjectToWorld, _pos);
            o.normal = normalize(mul(_Matrix, float4(_nrm, 0)));
			o.barycentricCoordinates = barycentricCoordinateArr(j);
			outStream.Append(o);
		}
		outStream.RestartStrip();
	}
}

float4 frag_wire(g2f_wire i) : SV_Target
{
	float3 albedo = _DiffuseColor.rgb;
	float3 specularTint;
	float oneMinusReflectivity;
	albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);
	float4 col = UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Glossiness, i.normal, normalize(UnityWorldSpaceViewDir(i.worldPos)), CreateLight(i.worldPos, i.normal), CreateIndirectLight_FWDBASE(i.normal));
	float3 barys;
    barys.xy = i.barycentricCoordinates;
    barys.z = 1 - barys.x - barys.y;
    float3 deltas = fwidth(barys);
	float3 smoothing = deltas * _WireframeSmoothing;
    float3 thickness = deltas * _WireframeThickness;
    barys = smoothstep(thickness, thickness + smoothing, barys);
    float minBary = min(barys.x, min(barys.y, barys.z));
	return float4(lerp(_WireframeColor, col.rgb, minBary).xyz, 1.0);
}

#endif