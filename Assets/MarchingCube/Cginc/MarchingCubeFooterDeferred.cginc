#ifndef MARCHINGCUBE_FOOTER_DEFERRED_INCLUDED
#define MARCHINGCUBE_FOOTER_DEFERRED_INCLUDED

#include "MarchingCubeHeader.cginc"
#include "MarchingCubeFooterCommon.cginc"

[maxvertexcount(15)]
void geom_light(point v2g input[1], inout TriangleStream<g2f_light> outStream)
{
    g2f_light o = (g2f_light) 0;
    int i, j;
    float1 cubeValue[8];
    float3 edgeVertices[12] = ZERO_ARRAY;
    float3 edgeNormals[12]  = ZERO_ARRAY;
    float3 pos = input[0].pos.xyz;
    float3 defpos = pos;

    for (i = 0; i < 8; i++) cubeValue[i] = Sample(pos + vertexOffset[i]);

    pos *= _Scale;
    pos -= 0.5;

    int flagIndex = 0;

    for (i = 0; i < 8; i++)
        if (cubeValue[i] <= _Threashold) flagIndex |= (1 << i);

    int edgeFlags = cubeEdgeFlags[flagIndex];
    if ((edgeFlags == 0) || (edgeFlags == 255)) return;

    float1 offset = 0.5;
    float3 vertex;
    for (i = 0; i < 12; i++) {
        if ((edgeFlags & (1 << i)) != 0) {
            offset = getOffset(cubeValue[edgeConnection[i].x], cubeValue[edgeConnection[i].y]);
            vertex = (vertexOffset[edgeConnection[i].x] + offset * edgeDirection[i]);
            edgeVertices[i] = pos + vertex * _Scale;
            edgeNormals[i] = getNormal(defpos + vertex);
        }
    }

    int vindex = 0;
    int findex = 0;
    for (i = 0; i < 5; i++) {
        findex = flagIndex * 16 + 3 * i;
        if (triangleConnectionTable[findex] < 0) break;

        for (j = 0; j < 3; j++) {
            vindex = triangleConnectionTable[findex + j];
            float4 ppos = mul(_Matrix, float4(edgeVertices[vindex], 1));
            o.pos = UnityObjectToClipPos(ppos);
            float3 norm = UnityObjectToWorldNormal(normalize(edgeNormals[vindex]));
            o.normal = normalize(mul(_Matrix, float4(norm, 0)));
            outStream.Append(o);
        }
        outStream.RestartStrip();
    }
}

void frag_light(g2f_light IN, out half4 outDiffuse : SV_Target0,
                              out half4 outSpecSmoothness : SV_Target1, 
                              out half4 outNormal : SV_Target2, 
                              out half4 outEmission : SV_Target3)
{
    fixed3 normal = IN.normal;
    float3 worldPos = IN.worldPos;
    fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

    SurfaceOutputStandard o = (SurfaceOutputStandard) 0;
    o.Albedo = _DiffuseColor.rgb;
    o.Emission = _EmissionColor * _EmissionIntensity;
    o.Metallic = _Metallic;
    o.Smoothness = _Glossiness;
    o.Alpha = 1.0;
    o.Occlusion = 1.0;
    o.Normal = normal;

    UnityGI gi;
    UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
    gi.indirect.diffuse = 0;
    gi.indirect.specular = 0;
    gi.light.color = 0;
    gi.light.dir = half3(0, 1, 0);
    gi.light.ndotl = LambertTerm(o.Normal, gi.light.dir);

    UnityGIInput giInput;
    UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
    giInput.light = gi.light;
    giInput.worldPos = worldPos;
    giInput.worldViewDir = worldViewDir;
    giInput.atten = 1.0;

    giInput.ambient = IN.sh;

    giInput.probeHDR[0] = unity_SpecCube0_HDR;
    giInput.probeHDR[1] = unity_SpecCube1_HDR;

    LightingStandard_GI(o, giInput, gi);

    outEmission = LightingStandard_Deferred(o, worldViewDir, gi, outDiffuse, outSpecSmoothness, outNormal);
    outDiffuse.a = 1.0;
}
		

[maxvertexcount(15)]
void geom_shadow(point v2g input[1], inout TriangleStream<g2f_shadow> outStream)
{
    g2f_shadow o = (g2f_shadow) 0;
    int i, j;
    float cubeValue[8];
    float3 edgeVertices[12] = ZERO_ARRAY;
    float3 edgeNormals[12]  = ZERO_ARRAY;
    float3 pos = input[0].pos.xyz;
    float3 defpos = pos;

    for (i = 0; i < 8; i++)
        cubeValue[i] = Sample(pos + vertexOffset[i]);

    pos *= _Scale;
    pos -= 0.5;

    int flagIndex = 0;

    for (i = 0; i < 8; i++)
        if (cubeValue[i] <= _Threashold) flagIndex |= (1 << i);

    int edgeFlags = cubeEdgeFlags[flagIndex];
    if ((edgeFlags == 0) || (edgeFlags == 255)) return;

    float offset = 0.5;
    float3 vertex;
    for (i = 0; i < 12; i++) {
        if ((edgeFlags & (1 << i)) != 0) {
            offset = getOffset(cubeValue[edgeConnection[i].x], cubeValue[edgeConnection[i].y], _Threashold);
            vertex = (vertexOffset[edgeConnection[i].x] + offset * edgeDirection[i]);
            edgeVertices[i] = pos + vertex * _Scale;
            edgeNormals[i] = getNormal(defpos + vertex);
        }
    }

    int vindex = 0;
    int findex = 0;
    for (i = 0; i < 5; i++) {
        findex = flagIndex * 16 + 3 * i;
        if (triangleConnectionTable[findex] < 0) break;

        for (j = 0; j < 3; j++) {
            vindex = triangleConnectionTable[findex + j];
            float4 ppos = mul(_Matrix, float4(edgeVertices[vindex], 1));
            float3 norm = UnityObjectToWorldNormal(normalize(edgeNormals[vindex]));
            float4 lpos1 = mul(unity_WorldToObject, ppos);
            o.pos = UnityClipSpaceShadowCasterPos(lpos1, normalize(mul(_Matrix, float4(norm, 0))));
            o.pos = UnityApplyLinearShadowBias(o.pos);
            o.hpos = o.pos;
            outStream.Append(o);
        }
        outStream.RestartStrip();
    }
}

float4 frag_shadow(g2f_shadow i) : SV_Target
{
    return i.hpos.z / i.hpos.w;
}
#endif