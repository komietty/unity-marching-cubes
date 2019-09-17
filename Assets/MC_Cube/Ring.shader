Shader "Custom/Ring"
{
	Properties { }
	SubShader
	{
		CGINCLUDE
		#include "../MarchingCube/Cginc/MarchingCubeHeader.cginc"
		#include "../MarchingCube/Cginc/DF_Primitive.cginc"
		#include "../MarchingCube/Cginc/DF_Utils.cginc"
		#include "../Packages/unity-gist/Cginc/SimplexNoise.cginc"

        float DistanceFunction(float3 p, float3 q)
		{
			q += snoise3D(float4(q, 1));
			float d0 = -torus(q, float2(0.3, 0.03));

			return d0 + 0.5;
        };
        
        #include "../MarchingCube/Cginc/MarchingCubeFooterWireframe.cginc"
		ENDCG

		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma geometry geom_wire
			#pragma fragment frag_wire_alt

            float4 frag_wire_alt(g2f_wire i) : SV_Target
            {
				float4 col = float4(_DiffuseColor.rgb, 1);
            	float3 barys;
            	barys.xy = i.barycentricCoordinates;
            	barys.z = 1 - barys.x - barys.y;
            	float3 deltas = fwidth(barys);
            	float3 smoothing = deltas * _WireframeSmoothing;
            	float3 thickness = deltas * _WireframeThickness;
            	barys = smoothstep(thickness, thickness + smoothing, barys);
            	float minBary = min(barys.x, min(barys.y, barys.z));
				float3 wCol = (abs(i.worldPos.z) < 1.5)? _WireframeColor : float3(1, 0, 0);
            	return float4(lerp(wCol, col.rgb, minBary).xyz, 1.0);
            }
			ENDCG
		}
	}
}
